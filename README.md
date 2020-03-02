**Features**

-   One-line to initialize and integrate in your the app ,published on iOs
    cocapods and android bintary

-   available for iOS and Android

-   open source : its code is available for public on [Github](https://github.com/appgain/)

-   Parse Server SDK initialization : no need to write extra code to initialize
    parse server SDK , its initialization is embedded in the
    [Appgain.io](http://appgain.io/) SDK initialization

-   User Push token identification : link each user push token with his app
    userId , enabling O2O communication

-   Deferred Deep Linking :

	-   for identifying the user app install acquisition channel

	-   to route the user flow to target app screen even if he didn't have the app
    installed before opening the smart Deep Link

-   Smart deep linking creation : create smart deep links within your app , for example on user share app content , this enables use cases like user rewarding

-   Mobile Deep Pages creation : create mobile deep pages  within your app , for example on user share app content , this enables use cases like user rewarding


-   Push Notifications Conversation Tracking :

	-   Track Push Message Received Event (Android only )

	-   Track Push Message Dismissed Event (Android only )

	-   Track Push Message Open Event

	-   Track Push MessageConversion Event

-   App Marketing Automation : trigger multi channel messaging predefined
    scenarios based on user In-App actions

-   Built-in User communication preference management : user can opt-out /opt-in
    to in app push, email, SMS channels




### Installing SDK

1 - Install SDK from cocoa Pod
  - Open terminal — 
 
  $ cd < your application directory>
  
  $ pod init.

  - Navigate to project directory will find podFile
  
  - Open it and add
  
  pod 'Appgain'.
  
  - press ctrl + S
  
  - Terminal 
  
  —$ pod update
  
  -OR-
  
  —$ pod install
  
  - Wait until pod finish install.
  
  - Open your project from <_____.xcworkspace

  2 - Configure SDK in app delegate.
  -   Allow application to access network.

1. You need to add your URL schema and Associated domain for your app , the value will be : <app subdomain. Appgain.io or your custom domain if you have confugured it

![](https://lh5.googleusercontent.com/-ouixZJ-c8hoykNRZKe6cIeC1capil9lGUYE4SWV1l12N13DF-zDUjoTl4QVUyOkzIFMOhLZnVBInQj9iIUqPNWZS3NEGzpfF_GYj2jEvR6HpJaS7SMF39dtKgDBdOjjn4oZZ7_M)
![](https://lh4.googleusercontent.com/jurvGVuWAMzY2MegbZ6yCTEjcc4wGCDzLrZ-gHaYMcgoNWZJg1LMPqtADliP2-O8pBwq7aVPo6WiSEd7uBhJ6wnDSFBXQZ4TqRRvbnc6qsT_Mhv1X4E8bpwmE0FC79maDvwFDAC0)

2. In AppDelegate.h, add #import <Appgain/Appgain.h

3. In AppDelegate.m

	     (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    [AppGain initializeAppWithID:<your app id  andApiKey: <—-your app api key —— whenFinish:^(NSURLResponse *response, NSMutableDictionary *result) {
	    //after app finish configure.
	    //response for match app to link.
	    //result show link matched data.}];
	    return YES;
	    }
	    
**Swift** —

• Create <project-name -Bridging-Header.h

• add this on it `#import <Appgain/Appgain.h`

• AppGain.initializeApp(withID: <your app id , andApiKey: <your app api key )
{ (response, result) in
}
