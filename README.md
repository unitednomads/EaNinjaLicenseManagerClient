# EA Ninja Client

The EA Ninja client library provides easy and consistent ways to access [EA Ninja](https://eaninja.eu). It should be imported into products written in the MQL4 language before their distribution.

## Installation

### Global installation

#### Git (recommended)

Under `YOUR_DATA_FOLDER / Includes`, run:

```
> git clone git@github.com:unitednomads/EaNinjaLicenseManagerClient.git
```

#### Manual

Download the library and extract under `YOUR_DATA_FOLDER`/`Includes`.

### Local installation

You may want to install this library in a local folder, such as `YOUR_DATA_FOLDER`/`Indicators`/`MyAwesomeIndicator`. In such case, import the library with directive:

```
#include "EaNinjaLicenseManagerClient/EaNinjaLicenseManagerClient.mqh"
```

If your local folder is a Git repository, you may install this library with `git submodule`.

## Usage

Always call `MyEaNinjaLicenseManagerClient.Auth()` at the beginning of `OnTick()` (for Expert Advisors) or `OnCompute()` (for indicators). You should not call `MyEaNinjaLicenseManagerClient.Auth()` in `init()` (legacy of `OnInit()`) as its execution time is [limited to 2.5 seconds](https://book.mql4.com/programm/special).

### Expert Advisors (EA)

```
// Activation identifier parameter
input string AuthKey = "";  //if identifier is "AuthKey"

// Under the parameters
#include <EaNinjaLicenseManagerClient/EaNinjaLicenseManagerClient.mqh>
EaNinjaLicenseManagerClient MyEaNinjaLicenseManagerClient("YOUR-DOMAIN.com", "pd_yourproduct", "VERSION"); //"VERSION" is optional

// In OnInit()
int OnInit() {
   MyEaNinjaLicenseManagerClient.SetInputLicenseKey(AuthKey); //if identifier is "AuthKey"
   MyEaNinjaLicenseManagerClient.SetActivationDidPerform(false);
}

// Prepend to OnTick()
int OnTick() {
   if(!MyEaNinjaLicenseManagerClient.Auth()){ return(0); }
}

// In OnDeinit()
void OnDeinit() {
   MyEaNinjaLicenseManagerClient.Clean();
}
```

### Indicators

Indicators, contrary to Expert Advisors, 

```
// Activation identifier parameter
input string AuthKey = "";  //if identifier is "AuthKey"

// Under the parameters
#include <EaNinjaLicenseManagerClient/EaNinjaLicenseManagerClient.mqh>
EaNinjaLicenseManagerClient MyEaNinjaLicenseManagerClient("YOUR-DOMAIN.com", "pd_yourproduct", "VERSION"); //"VERSION" is optional

// In OnInit()
int OnInit() {
   MyEaNinjaLicenseManagerClient.SetInputLicenseKey(AuthKey); //if identifier is "AuthKey"
   MyEaNinjaLicenseManagerClient.SetActivationDidPerform(false);
}

// Prepend to OnCompute()
int OnCompute() {
   if(!MyEaNinjaLicenseManagerClient.Auth()){ return(0); }
}

// In OnDeinit()
void OnDeinit() {
   MyEaNinjaLicenseManagerClient.Clean();
}
```

## OpenUrl feature

There are cases where you want to redirect users to a web page, such as when the license of your user has expired. You can set in the web portal those URLs you want your users redirect to.  When using this feature, please note that this feature must be explicitly enabled by calling `SetIsOpenUrlEnabled(true)` in your EA/indicator.

EA/indicators for multiple symbols requires some attention when using it. Please consider limiting symbols to enable this feature with in order to prevent too many browser tabs popping out.

## EA/indicator sets with many files

Some EAs and indicators consist of many "child" EAs and indicators. For example, an indicator displaying signals may have a customized Moving Average indicator in the package to help traders make decisions. Those "child" indicators, which are unlikely to be useful without the main indicator, or "parent" indicator, should use the **follower mode**. When follower mode is enabled by calling `SetIsFollower(true)`, the EA/indicator only attempts to read the result saved in the global variables.

When in the follower mode, the EA/dicator does NOT:
* make a request to EaNinja
* open a browser, even when the OpenUrl feature is enabled

### Customization

You can configure MyEaNinjaLicenseManagerClient by setting attributes as follows:

| Function | Description |
| - | - |
| `SetIsFollower(bool isFollower)` | Always use the result stored in the global variables. |
| `SetIsOpenUrlEnabled(bool isOpenUrlEnabled)` | Use the OpenUrl feature. |
| `SetDllErrorMessage(string message)` | Set a message to be alerted if DLL import is disabled. |
| `SetTextWindow(int window)` | Set a window in which activation messages are rendered. |
| `SetTextPosX(int pos_x)` | Set a horizontal position of the text message. |
| `SetTextPosY(int pos_y)` | Set a vertical position of the text message. |
| `SetTextCorner(int corner)` | Set a corner at which the text message is rendered. |
| `SetTextFontSize(int fontSize)` | Set a font size of the text message rendered. |
| `SetTextFontName(string fontName)` | Set a font of the text message rendered. |
| `SetActivationSuccessColor(color clrCode)` | Set a color of the message rendered after a successful activation. |
| `SetActivationErrorColor(color clrCode)` | Set a color of the message rendered after a failed activation. |
| `SetActivationForcedSuccessMessage(string message)` | Set a message after a successful activation, overriding one set on EaNinja console. |
| `SetActivationForcedErrorMessage(string message)` | Set a message after a failed activation, overriding one set on EaNinja console. |

## Encoding

Because of the limitations of github/bitbucket and MQL4, text files are encoded from **UTF-16** to **UTF-8** before being pushed to `origin`. A line including 2-byte characters are inserted in the beginning of each text files to ensure them being in UTF-16 format. Without it, MetaEditor may save it in ASCII.

```
# .gitattributes
*.mq4 filter=utf16
*.mqh filter=utf16
```

```
# .git/config
[filter "utf16"]
	clean = iconv -f utf-16le -t utf-8
	smudge = iconv -f utf-8 -t utf-16le
```

## Dependencies

This client library assumes the following to be present in your `Includes` folder, which are most likely installed by default. 

* stdlib.mqh
* WinUser32.mqh