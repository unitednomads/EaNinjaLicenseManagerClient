// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                                  LabelHelper.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

void EaNinjaLicenseManagerClient::RenderActivationUserMessage()
{
   color clrCode;
   if(IsActivated()){
      clrCode = m_activation_success_color;
   }else{
      clrCode = m_activation_error_color;
   }
   
   RenderTextLabel(
      "activation-user-message", m_activation_user_message, clrCode
   );
}

void EaNinjaLicenseManagerClient::RenderTextLabel(string label, string text, color clrCode)
{
   string name = StringConcatenate(TextLabelPrefix(), label);
   
   if(ObjectFind(name) < 0){
      ObjectCreate(name, OBJ_LABEL, 0, m_text_window, 0, 0);
   }
   
   ObjectSet(name, OBJPROP_COLOR, clrCode);
   ObjectSet(name, OBJPROP_XDISTANCE, m_text_pos_x);
   ObjectSet(name, OBJPROP_YDISTANCE, m_text_pos_y); 

   ObjectSet(name, OBJPROP_CORNER, m_text_corner);   
   ObjectSet(name, OBJPROP_FONTSIZE, m_text_font_size);
   ObjectSetText(name, text, m_text_font_size, m_text_font_name);
}

void EaNinjaLicenseManagerClient::DeleteTextLabels()
{
   string name;
   for(int i=0; i < ObjectsTotal(); i++){
      name = ObjectName(i);
      if(TextLabelPrefix() == StringSubstr(name, 0, StringLen(TextLabelPrefix()))){
         ObjectDelete(name); i--;
      }
   }
}

string EaNinjaLicenseManagerClient::TextLabelPrefix(){
   return(StringConcatenate(WindowExpertName(), "-"));
}