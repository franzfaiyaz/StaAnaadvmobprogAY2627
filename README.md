# Lab Activity 1 – Counter Application with Dark/Light Mode Using Provider

## Discussion

In this lab activity, I learned how to implement state management in Flutter using both Ephemeral State and App State. The counter functionality uses `setState()` to update the counter value whenever the increment (+) or decrement (-) button is pressed. This demonstrates Ephemeral State because the state only affects a specific widget.

I also implemented a Dark Mode and Light Mode feature using the `Provider` package. This demonstrates App State because the selected theme affects the entire application and can be accessed across multiple screens. Through this activity, I gained a better understanding of Flutter widgets, state management, navigation, and theme customization.
 
# Lab Activity 1 – Counter Application with Dark/Light Mode Using Provider

## Student Information

**Name:** Justine Francis Sta. Ana  

**Course:** CTADMOBL – Advance Mobile Programming  

**Lab Activity:** Lab Activity 1

---

## Project Overview

This Flutter application demonstrates the implementation of Ephemeral State and App State Management. The application includes a counter feature with increment (+) and decrement (-) functionality, as well as a Dark Mode and Light Mode feature using the Provider package.

### Features

- Counter Increment (+)

- Counter Decrement (-)

- Theme Settings Screen

- Dark Mode / Light Mode Toggle

- State Management using setState()

- State Management using Provider

---

## Discussion

Sa lab activity na ito, natutunan ko kung paano gamitin ang iba't ibang uri ng state management sa Flutter. Gumamit ako ng **setState()** para sa counter functionality dahil ito ay isang halimbawa ng Ephemeral State kung saan ang pagbabago ng value ay nakakaapekto lamang sa isang widget o screen.

Bukod dito, gumamit din ako ng **Provider** para sa Dark Mode at Light Mode feature. Ito naman ay isang halimbawa ng App State dahil ang pagbabago ng theme ay naaapektuhan ang buong application at maaaring magamit sa iba't ibang bahagi ng app.

Sa paggawa ng activity na ito, mas naunawaan ko kung paano mag-manage ng state sa Flutter at kung kailan dapat gamitin ang setState() at Provider. Natutunan ko rin kung paano gumawa ng mas organisado at mas madaling i-maintain na mobile application gamit ang tamang state management techniques.

---

## Technologies Used

- Flutter

- Dart

- Provider Package

- Android Emulator

- Visual Studio Code

---

## Output

The application successfully demonstrates:

- Counter value increment and decrement

- Theme switching between Light Mode and Dark Mode

- Ephemeral State using setState()

- App State using Provider

---
 
## Lab Activity 2: Discussion

**Ano ang natutunan ko**

Sa activity na ito, natutunan ko kung paano gumawa ng simple pero organisadong shopping app gamit ang Flutter. Nakita ko kung paano ihiwalay ang data, UI, at state para mas madaling i-maintain ang project. Mas malinaw rin ang flow ng app dahil ang `HomeScreen` lang ang nagre-request ng produkto mula sa `ProductService`, at kapag may pinindot na item, dinadala ang buong `Product` object sa `ProductScreen` para doon ipakita ang detalye.

**Paano ginamit ang assets/images**

Ginamit ko rin ang `assets/images/` para sa mga product thumbnail at UI icon. Dahil naka-register na ang assets sa `pubspec.yaml`, mas madali itong gamiting sa `Image.asset()` o `Image.network()` kapag nag-load ng images sa app. Importante na nakaayos ang assets folder para hindi magka-issue sa build kapag nagpakita ng image sa screen.

**Project structure**

- Model: `product_model.dart` para sa `Product` data structure.
- Service: `product_service.dart` para sa pagkuha ng listahan ng produkto at para maging handa sa future API integration.
- Screens: `home_screen.dart`, `product_screen.dart`, at `settings_screen.dart` para sa UI.
- Provider: `theme_provider.dart` para hawakan ang Dark/Light Mode state sa buong app.

**Enhancements**

- Search bar: Naglagay ng search filter sa `home_screen.dart` para makahanap agad ng produkto base sa pangalan o description.
- Product details: Pag-tap sa item, pupunta sa `product_screen.dart` para makita ang buong detalye ng produkto.
- Settings page: May toggle para sa Dark Mode at Light Mode gamit ang `Provider`.

**Reflection**

Mas na-appreciate ko dito kung paano pinaghihiwalay ang data at UI sa Flutter app. Na-realize ko rin na kahit maliit ang project, malaking tulong ang mga assets at maayos na folder structure kapag nagpapakita ng imahe. Sana sa susunod, mas marami pa akong matutunan sa pag-integrate ng tunay na API at `.env` configuration para sa mas professional na app setup.

 