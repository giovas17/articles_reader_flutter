# Articles Reader

A new Flutter project that reads articles.

## Getting Started

This project was developed using Android Studio. In order to see it you can open it using
Visual Studio or Android Studio, once you get it, you need to get all the dependencies from PUB.

```
flutter pub get
```

The code is using MVVM architecture and some patterns such as Repository in order to handle
the data that comes from the DB or the API

### Screens

There a few screens developed to show the data:
- Articles List --> As te name said shows the list of articles that comes from the API and allows the user to mark as favorite each element of the list
- Article Detail --> Just receive an article object an show all the properties
- Favorites --> This is screen is only available for Android and iOS, read the data for the embedded DB (Sqlite3 was used to create the DB)

### Considerations
Even the app was developed for Android, iOS and Web, the Web part cannot mark as favorite an element, this is because the implementation of the DB for WEB can take so much time for the exercise and was not part of the requirements

- The Database was created using SQLite natively using `sqflite_common_ffi`
- The creation of the VM for the list was using Provider and maintains the state for the lifecycle of the view what allow us to use different approaches for the refresh
- The automatic refresh is made every 15 mins, this approach uses the lifecycle of the app in order to active or deactivate this behaviour

### Testing
The app contains all the tests made for every part of the code used. you can run all of them if you search for file:

```
test/all_test.dart 
```
All the other files were used to mock or split the tests for different sections of the app.