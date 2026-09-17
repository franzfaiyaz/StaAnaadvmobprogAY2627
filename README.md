# Lab Activity 5: Firebase Authentication and UserService

## Student Information

Name: Justine Francis Sta. Ana

Course: CTADMOBL – Advance Mobile Programming

Lab Activity: Lab Activity 5

## Discussion

### DummyJSON and Firebase workflow
The application supports two separate authentication workflows. The DummyJSON workflow sends the username and password to `https://dummyjson.com/auth/login`. When the API returns a successful response, the application saves the returned user information and access token with `SharedPreferences`, then opens the home screen. The saved token is checked by the splash screen when the application is opened again. DummyJSON accounts and Firebase accounts are separate and cannot be used interchangeably.

The Firebase workflow uses the Firebase Authentication SDK. A new user completes the signup form with their first name, last name, age, contact number, username, email address, and password. `createUserWithEmailAndPassword()` creates the Firebase account, while the profile information and refreshed Firebase ID token are saved locally. During sign-in, the user selects Firebase and enters the email address and password registered in Firebase. Firebase then validates the credentials and returns the authenticated user.

### Workflow from sign-in to sign-up
The sign-in screen lets the user choose either DummyJSON or Firebase. The selected option is passed to `UserService.signIn()`, which calls the matching authentication implementation. A user who does not have a Firebase account can open the signup screen and complete the validated registration form. After successful registration, the application opens the home screen. The splash screen checks the saved session on later launches and redirects either to the home screen or back to sign-in.

### Main idea of UserService
`UserService` is the central service layer for authentication and user data. It keeps network requests, Firebase SDK calls, token refresh, local session storage, logout, username updates, password changes, and account deletion out of the widgets. The screens are responsible for collecting input and showing results, while `UserService` handles the authentication rules and data flow. This separation makes the application easier to test, maintain, and extend.

### Benefits of Firebase in this application
Firebase Authentication provides a production-oriented identity system instead of requiring the application to manage passwords itself. It provides secure email and password authentication, managed sessions, token refresh, account creation, reauthentication before changing a password, and account deletion. Firebase Authentication can also be combined with Firebase security rules so that protected data is available only to the authenticated user.

Compared with the demonstration DummyJSON API, Firebase gives the application better control over account ownership and security. DummyJSON is useful for practicing API requests and displaying user data, but it is not the application's own authentication database. Firebase is therefore more suitable for the current Flutter application when real user accounts, persistent sessions, and protected backend data are required.


## Implemented Enhancements

- Firebase and DummyJSON sign-in through `UserService`.
- Firebase account creation with signup validation.
- Firebase ID-token refresh and persistent sessions.
- Username update, password change, account deletion, and sign-out.
- Profile display based on the current `LoginType`.
- Logout from the profile and settings screens with a redirect to sign-in
