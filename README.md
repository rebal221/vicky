
# Vicky

It is a virtual assistant, built with Flutter & Dart that can help with some tasks and is able to help with software solutions
## Installation

Add these permissions to this file : android > app > src > main > AndroidManifest.xml
```xml
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
    <queries>
        <intent>
            <action android:name="android.speech.RecognitionService" />
        </intent>
    </queries>
    <queries>  
        <intent>  
            <action android:name="android.intent.action.TTS_SERVICE" />  
        </intent>  
    </queries>  
```
After that, modify this minSdkVersion from : android > app > build.gradle > to 21
```gradle
  minSdkVersion 21 

```
When completing the previous operations, type this command in the terminal 
```shel
  flutter packages get
```
When completing Run the project
## Screenshots

![App Screenshot](https://github.com/rebal221/vicky/blob/67b442778cf4d63d0e63b216aad98cd2d2d29043/asstes/images/screen1.jpg?raw=true)
![App Screenshot](https://github.com/rebal221/vicky/blob/67b442778cf4d63d0e63b216aad98cd2d2d29043/asstes/images/screen2.jpg?raw=true)


## Author

- [Rebal Aljrmani](https://github.com/rebal221)

