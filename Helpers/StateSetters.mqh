// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                                 StateSetters.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

string EaNinjaLicenseManagerClient::SetEaNinjaDomain(string fqdn){
   m_ea_ninja_domain = fqdn;
   return(m_ea_ninja_domain);
}

string EaNinjaLicenseManagerClient::SetProductUid(string product_uid){
   m_product_uid = product_uid;
   return(m_product_uid);
}

string EaNinjaLicenseManagerClient::SetProductVersion(string version){
   m_product_version = version;
   return(m_product_version);
}

bool EaNinjaLicenseManagerClient::SetActivationDidPerform(bool activationDidPerform){
   m_activation_did_perform = activationDidPerform;
   return(m_activation_did_perform);
}

bool EaNinjaLicenseManagerClient::SetIsDebug(bool isDebug){
   m_is_debug = isDebug;
   return(m_is_debug);
}

string EaNinjaLicenseManagerClient::SetDllErrorMessage(string message){
   m_dll_error_message = message;
   return(m_dll_error_message);
}

bool EaNinjaLicenseManagerClient::SetIsFollower(bool isFollower){
   m_is_follower = isFollower;
   return(m_is_follower);
}

bool EaNinjaLicenseManagerClient::SetIsOpenUrlEnabled(bool isOpenUrlEnabled){
   m_is_open_url_enabled = isOpenUrlEnabled;
   return(m_is_open_url_enabled);
}

bool EaNinjaLicenseManagerClient::SetIsActivated(bool isActivated){
   if(isActivated){
      GlobalVariableSet(ActivationStatusGlobalVariableKey(), 1.0);
   }else{
      GlobalVariableSet(ActivationStatusGlobalVariableKey(), 0.0);
   }
   m_is_activated = isActivated;
   RenderActivationUserMessage();
   return(m_is_activated);
}

string EaNinjaLicenseManagerClient::SetInputLicenseKey(string licenseKey){
   m_input_license_key = licenseKey;
   return(m_input_license_key);
}

string EaNinjaLicenseManagerClient::SetActivationUserMessage(string userMessage){
   m_activation_user_message = userMessage;
   RenderActivationUserMessage();
   return(m_activation_user_message);
}

color EaNinjaLicenseManagerClient::SetActivationSuccessColor(color clrCode){
   m_activation_success_color = clrCode;
   RenderActivationUserMessage();
   return(m_activation_success_color);
}

color EaNinjaLicenseManagerClient::SetActivationErrorColor(color clrCode){
   m_activation_error_color = clrCode;
   RenderActivationUserMessage();
   return(m_activation_error_color);
}

string EaNinjaLicenseManagerClient::SetActivationForcedSuccessMessage(string message){
   m_activation_forced_success_message = message;
   RenderActivationUserMessage();
   return(m_activation_forced_success_message);
}

string EaNinjaLicenseManagerClient::SetActivationForcedErrorMessage(string message){
   m_activation_forced_error_message = message;
   RenderActivationUserMessage();
   return(m_activation_forced_error_message);
}

int EaNinjaLicenseManagerClient::SetTextWindow(int window){
   m_text_window = window;
   RenderActivationUserMessage();
   return(m_text_window);
}

int EaNinjaLicenseManagerClient::SetTextPosX(int pos_x){
   m_text_pos_x = pos_x;
   RenderActivationUserMessage();
   return(m_text_pos_x);
}

int EaNinjaLicenseManagerClient::SetTextPosY(int pos_y){
   m_text_pos_y = pos_y;
   RenderActivationUserMessage();
   return(m_text_pos_y);
}

int EaNinjaLicenseManagerClient::SetTextCorner(int corner){
   m_text_corner = corner;
   RenderActivationUserMessage();
   return(m_text_corner);
}

int EaNinjaLicenseManagerClient::SetTextFontSize(int fontSize){
   m_text_font_size = fontSize;
   RenderActivationUserMessage();
   return(m_text_font_size);
}

string EaNinjaLicenseManagerClient::SetTextFontName(string fontName){
   m_text_font_name = fontName;
   RenderActivationUserMessage();
   return(m_text_font_name);
}

string EaNinjaLicenseManagerClient::ActivationStatusGlobalVariableKey(){
   return(StringConcatenate("activation-status-", m_product_uid));
}
