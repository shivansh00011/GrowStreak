
# GrowStreak

GrowStreak is a productivity and task management app built with Flutter. The app allows users to manage their tasks by adding and deleting them upon completion. Additionally, it features an AI assistant, powered by a fine-tuned Gemini model, to provide productivity tips and answer user queries about improving productivity or other related topics.




### Features

**Task Management:**
    
* Add tasks and manage daily goals.
* Mark tasks as completed or delete them when done.
* Tasks are securely stored in Firebase Firestore.

**User Authentication:** 

* Login, Signup and logout functionality.
* Forgot password feature integrated with Firebase Authentication.

**AI Productivity Assistant:**

* Ask the AI assistant questions about productivity or related topics.
* Powered by a fine-tuned **Gemini** model hosted on Google Cloud.
    

### Getting Started
Follow these steps to set up and run **GrowStreak**.

**Flutter:** Install Flutter.

**Firebase:** Set up a Firebase project.

**Google Cloud Platform (GCP):** Fine-tune and deploy your Gemini model.





## Installation

**Clone the repository:**

```bash
  git clone https://github.com/shivansh00011/GrowStreak.git 
  cd GrowStreak  

```

**Set Up Firebase:**

* Create a Firebase project in the Firebase Console.

* Enable the following services:
    * **Authentication:** Set up email/password sign-in method.
    * **Firestore Database:** For storing tasks.

* Download the google-services.json file for Android and place it in the **android/app/** directory.
* Download the GoogleService-Info.plist file for iOS and place it in the **ios/Runner** directory.


**Set Up Google Cloud for AI Api Working:**
* Fine-tune the Gemini model for productivity-related queries on Google Ai Studio.
* Deploy the model as an API endpoint.
* Note the API endpoint and access token.

**Install Dependencies:**

```bash
flutter pub get  

```
**Run the App:**

```bash
flutter run   

```


### Usage

**User Authentication:** 
* **Login:** Use your email and password to log in.
* **Sign Up:** Create an account to start using the app.
* **Forgot Password:** Reset your password if needed.
**Task Management:** 
* Add tasks to track your daily goals.
* Delete tasks when completed.
* Tasks are saved to Firebase Firestore and can be accessed anytime.

**AI Assistant:** 

* Navigate to the AI section in the app.

* Ask the AI assistant productivity-related questions.

* The AI, powered by the Gemini model, will provide helpful tips and responses.


### Technologies Used

* **Flutter:** Cross-platform mobile app development.

* **Firebase:** Backend for user authentication and Firestore for task management.
* **Google Cloud Platform (GCP):** Fine-tuned Gemini model for AI responses.

### Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to enhance the functionality or fix bugs.

