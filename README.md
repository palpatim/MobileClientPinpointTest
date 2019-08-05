# MobileClientPinpointTest
A sample app to test integration of AWSMobileClient with Pinpoint events

## Prepare working directory

- git clone https://github.com/palpatim/MobileClientPinpointTest.git
- `pod install`

## Set up your backend

### Option 1: Amplify CLI

To enable auth events from Cognito User Pools to Pinpoint, you must set up your Amplify project in the `us-east-1` region. If
you do not need Cognito User Pools to send auth events to Pinpoint, you may use any available region, and skip the
"PinpointAppId" steps in the Cognito User Pools configuration below.

- `amplify init`
- `amplify add auth` (Accepting defaults)
- `amplify add analytics` (Accepting defaults)

### Option 2: Manual Configuration

- Set up a Pinpoint project
  - To enable auth events from Cognito User Pools to Pinpoint, you must set up your Pinpoint project in the `us-east-1` region.
  - If you do not need Cognito User Pools to send auth events to Pinpoint, you may use any available region, and skip the
    "PinpointAppId" steps in the Cognito User Pools configuration below.

- Set up a Cognito User Pool
  - In the **App clients** section, generate an App Client. You will need both the **App client id** and **App client
    secret** below.

- Set up a Cognito Identity Pool
  - Create a new Identity Pool
  - In the **Unauthenticated identities** section, check **Enable access to unauthenticated identities**
  - In the **Authentication providers** section, on the **Cognito** tab, enter the User Pool ID and App client ID you
    created above
  - Create both authenticated and unauthenticated roles

- Configure the app
  - Edit the `awsconfiguration.json` file with the appropriate values for:
    - **CredentialsProvider > CognitoIdentity > Default**
      - **PoolId**: The Identity Pool ID from your Cognito Identity Pool
      - **Region**: The AWS region in which you created your Cognito Identity Pool
    - **CognitoUserPool > Default**
      - **PoolId**: The User Pool ID from your Cognito User Pool
      - **AppClientId**: The App client ID from the Amazon Cognito app client you created above
      - **AppClientSecret**: The App client secret from the Amazon Cognito app client you created above
      - **Region**: The AWS region in which you created your Cognito User Pool
    - **Pinpoint**
      - **AppId**: The Pinpoint app ID from the Pinpoint project you created above
      - **Region**: The AWS region in which you created your Pinpoint App. This **must** be `us-east-1`.

## Optional: Enable Cognito User Pool auth events in Pinpoint

**NOTE: If you do not wish to enable Cognito User Pool events in Pinpoint, remove the **PinpointAppId** entry from the *CognitoUserPool > Default* section of `awsconfiguration.json`**

- Navigate to the Cognito User Pools console
  - In the **Analytics** section, after you refresh the page to ensure you have access to the latest resources in your account:
    - Select the **Amazon Cognito app client** you just generated
    - From the "Amazon Pinpoint project" field, select the Pinpoint project you just created. If the console does not show
      the Pinpoint project, ensure you created it in the `us-east-1` region.
    - In the **IAM role** field, enter a name for a new role, then click **Create role**
  - Save the modified Cognito User Pool
- Edit the `awsconfiguration.json` file with the appropriate values for:
  - **CognitoUserPool > Default**
    - **PinpointAppId**: The Pinpoint app ID from the Pinpoint project you created above

## Run the app

- Launch the app
- Sign up a new user
- Inspect the console logs. You should see a authentication traffic and Pinpoint session events, with no errors.

- If you enabled Cognito User Pools events in Pinpoint, you should also see log messages with a payload like:
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

- Inspect events in your Pinpoint console. You should see session and custom events:

- If you enabled Cognito User Pools events in Pinpoint, you should also see auth events like:
  - `_userauth.sign_in`
  - `_userauth.sign_up`
