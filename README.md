# MobileClientPinpointTest
A sample app to test integration of AWSMobileClient with Pinpoint events

## Setting up your backend

- Set up a Pinpoint project in the `us-east-1` region

- Set up a Cognito User Pool
  - In the **App clients** section, generate an App Client. You will need both the **App client id** and **App client
    secret** below.
  - In the **Analytics** section, after you refresh the page to ensure you have access to the latest resources in your account:
    - Select the **Amazon Cognito app client** you just generated
    - From the "Amazon Pinpoint project" field, select the Pinpoint project you just created. If the console does not show
      the Pinpoint project, ensure you created it in the `us-east-1` region.
    - In the **IAM role** field, enter a name for a new role, then click **Create role**
  - Save the modified Cognito User Pool

- Set up a Cognito Identity Pool
  - Create a new Identity Pool
  - In the **Unauthenticated identities** section, check **Enable access to unauthenticated identities**
  - In the **Authentication providers** section, on the **Cognito** tab, enter the User Pool ID and App client ID you
    created above
  - Create both authenticated and unauthenticated roles

## Configuring the app

- Clone this repository
- `pod install`
- Edit the `awsconfiguration.json` file with the appropriate values for:
  - **CredentialsProvider > CognitoIdentity > Default**
    - **PoolId**: The Identity Pool ID from your Cognito Identity Pool
    - **Region**: The AWS region in which you created your Cognito Identity Pool
  - **CognitoUserPool > Default**
    - **PoolId**: The User Pool ID from your Cognito User Pool
    - **AppClientId**: The App client ID from the Amazon Cognito app client you created above
    - **AppClientSecret**: The App client secret from the Amazon Cognito app client you created above
    - **Region**: The AWS region in which you created your Cognito User Pool
    - **PinpointAppId**: The Pinpoint app ID from the Pinpoint project you created above
  - **Pinpoint**
    - **PinpointAppId**: The Pinpoint app ID from the Pinpoint project you created above
    - **Region**: The AWS region in which you created your Pinpoint App. This **must** be `us-east-1`.

## Run the app

- Launch the app
- Sign up a new user
- Inspect the console logs. You should see a log message with a payload like:
    ```json
    {
      "AnalyticsMetadata": {
        "AnalyticsEndpointId": "xxx"
      },
      "UserContextData": {
        "EncodedData": "XXX"
      },
      "ClientMetadata": {
        // ...
      },
      "AuthParameters": {
        // ...
      },
      "AuthFlow": "USER_SRP_AUTH",
      "ClientId": "XXX"
    }
    ```
- Inspect events in your Pinpoint console. You will see auth events like:
  - `_userauth.sign_in`
  - `_userauth.sign_up`