# Advanced Mobile Programming Lab Documentation

## Student Information

**Name:** Justine Francis Sta. Ana

**Course:** CTADMOBL - Advance Mobile Programming

**Coverage:** Lab Activities 1-6

## Lab Activity 1: Counter Application with Dark/Light Mode Using Provider

In this activity, I worked on an application that uses state management in Flutter. I used `setState()` to manage the counter value. Each time I pressed the increase or decrease button, the counter updated immediately. This is an example of ephemeral state because the counter changes within a specific screen and does not affect the whole app.

I also added dark mode and light mode using the Provider package. Provider helps manage app state because the theme selection affects the entire application and can be accessed by any screen. This activity helped me understand how to use Flutter widgets such as buttons, text and containers. I also practiced navigation between screens and learned how to customize themes. Overall, I now understand when to use `setState()` for local state changes and when to use Provider for shared state across the app.

## Lab Activity 2: Product API Integration

This activity focused on connecting a Flutter app to an API. I created a Product model that holds data such as the title, price, description and images. The model uses `fromJson()` to convert JSON from the API into Dart objects.

I built a ProductService to handle communication with the DummyJSON API. The service sends requests to the products endpoint and converts the response into a list of Product objects. On the HomeScreen, I used this service to load and display all products. When an item is tapped, the app navigates to the ProductScreen and passes the selected product for details.

I also added loading and error states so the app behaves properly while waiting for data or when something goes wrong. This project introduced me to the Service Pattern, which keeps networking logic separate from the UI. This makes the code easier to test, update and maintain while reducing clutter in the screens.

## Lab Activity 3: Cart API Integration and Product Navigation

In this activity, I added cart functionality using the DummyJSON Cart API. I defined two models: Cart and CartProduct. These models structure the cart data and use `fromJson()` and `toJson()` to process API responses.

The CartService handles interactions with the cart API, including getting all carts, retrieving a user's cart and adding items. I implemented a CartScreen that shows the shopping cart contents. Each item includes an image, title, price, quantity and discount information. Users can tap any item to go to the ProductScreen using the product ID.

To improve usability, I added a FloatingActionButton on the HomeScreen that opens the CartScreen. I made sure it does not appear on the CartScreen itself. This activity improved the shopping experience by combining API integration with smooth navigation. It also allowed users to view their cart data and taught me how to manage user data while keeping the flow intuitive.

## Lab Activity 4: User Authentication and Persistent Login

In this lab, I implemented user authentication and persistent login. I used the DummyJSON API along with SharedPreferences for storing user data. The User model holds information such as the user ID, username, email, name, gender, image, access token and refresh token.

The UserService manages login operations. It sends a request to the API and converts the response into a User object. Once logged in, the user's data is saved in SharedPreferences so it remains available after the app restarts.

I created a custom SplashScreen that checks whether a token exists. If a token exists, the user goes to the HomeScreen; otherwise, they are sent to the SignInScreen. The ProfileScreen loads the saved user data and uses the user ID to retrieve the correct profile and cart. This activity taught me how models, services, screens and local storage can work together to create a reliable login system.

## Lab Activity 5: Firebase Authentication and UserService

This activity expanded the authentication system by adding Firebase Authentication to the existing DummyJSON login. Users can now choose between logging in with DummyJSON or Firebase.

The UserService manages both authentication methods. With Firebase, users can create accounts using their email and password. They can also provide details such as their name, age, contact number and username. Firebase handles account creation, login sessions, token refresh, password changes, reauthentication and account deletion.

The app saves user data locally so the session continues even after closing and reopening the app. I added validation for Firebase and DummyJSON sign-in, profile editing and logout features, all handled by the UserService. This activity showed me how Firebase provides a complete authentication solution. It also reinforced the importance of separating business logic from the UI, making the code cleaner and easier to maintain.

## Lab Activity 6: Firestore User Profiles and Chat System

When a Firebase account is created or a user signs in, the application stores the user's profile in the `Users` collection. The Firebase UID is used as the document ID and is also saved in the `uid` field. The document contains profile information such as the email address, first name, last name, username, age, phone number and profile image. Authentication tokens and passwords are not saved in this collection.

Each conversation is saved in `chat_rooms/{chatRoomId}/messages`. The room ID is created by sorting the two Firebase UIDs and then joining them with an underscore. Because the same two IDs create the sorted value, both users end up in the same room.

Each message document has the sender UID and email, the message text and a Firestore timestamp. The application watches the `messages` subcollection using Firestore snapshots ordered by timestamp. When a message is sent or received, the stream updates the chat screen without needing a refresh.

The chat list leaves out the signed-in Firebase user so they cannot choose themselves. The chat service also checks the sender and receiver UIDs before starting a conversation or sending a message. If they are the same, the action is blocked with an error message.

## Overall Reflection

These activities helped me understand Flutter state management, API integration, navigation, authentication, local storage and Firestore. I learned how models, services and screens work together to create a more organized and maintainable application. I also learned the importance of separating business logic from the user interface and protecting sensitive user information.