# RubyMotion Notes

<http://rubymotion.com>

Create a project:

  motion create MyProject
  
Build and run the simulator to see your project:

  rake
  
RubyMotion has special named parameter syntax.

Cocoa touch delegates back into your application.
There are many methods in your application that are called by the
framework:

  AppDelegate
  application:didFinishLaunchingWithOptions:
  applicationDidBecomeActive:
  applicationWillResignActive:
  applicationDidEnterBackgroud:
  applicationWillEnterForeground:
  applicationWillTerminate:
  
Entry point to add our own application specific code:

  class AppDelegate
    def application(application,
didFinishLaunchingWithOptions:launchOptions)
      true
    end
  end
  
You can create an alert by instantiating an alert view class and give it
a message:


  class AppDelegate
    def application(application,
didFinishLaunchingWithOptions:launchOptions)
      alert = UIAlertView.new
      alert.message = "Hello World!"
      alert.show
      true
    end
  end

Every iOS app has a single window it's where it shows the views.

Objective-C calls are in the form:

  [receiver method: parameter]
  
  the message is-
  method: parameter
  

The Objective-C for creating a window is:

  UIWindow *window = [[UIWindow alloc] initWithFrame:frame];
  
`[[UIWindow alloc] initWithFrame:frame]` is a nested message call.

1. `[UIWindow alloc]` - creates a new UIWindow object, by calling alloc
   on UIWindow
2. `initWithFrame:frame` - initWithFrame is then called on the UIWindow
   object, passing in a frame object
3. `UIWindow *window` - the UIWindow object is then assigned to the
   'pointer' variable `*window` of type `UIWindow`

The Ruby version of the Objective-C code:

  @window = UIWindow.alloc.initWithFrame(frame)
  
We need to use `@window` to prevent the window object from being
prematurely garbage collected.

Now we can create a boundary frame:

  class AppDelegate
    def application(application,
didFinishLaunchingWithOptions:launchOptions)
      @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
      @window.backgroundColor = UIColor.yellowColor
      @window.makeKeyAndVisible
      true
    end
  end

`mainScreen` returns the main screen of the device. It has a `bounds`
method which returns the boundary of the device's screen.

`@window.makeKeyAndVisible`, makes this the key window and displays it.

## RubyMotion console

After typing `rake` your simulator starts but also you have a console.
If you hold down `Cmd` and click on the simulator you can get access to
objects in the console.

Type in `self` to get access to what you just clicked on.

  self.backgroundColor = UIColor.blueColor
  sessions
    => [main, #<UIWindow:0x234234>]
  quit # takes you out of the session
  app = UIApplication.sharedApplication
  app.delegate
  delegate = app.delegate
  repl(delegate)
    # now the context is the application delegate


### Rake, Configuration and Icons

Add your icon to the resources directory. Then change the `Rakefile`, by
appending the icon name to the `app.icons` array e.g. in the Rakefile

  app.name = 'My Project Name
  app.icons << 'icon.png'
  
To see the configuration:

  rake config

To clean and run the app

  rake clean=1
  

## Code Undersatanding

A Window is just a code container for one or more views.
So the window needs a `rootViewController`

### View controllers

Create a view controller as such:

  class MyViewController < UIViewController
  end

A view controller can manage one or more views.  
Views controllers have a set of standard callback methods:

  loadView
  viewDidLoad
  viewDidUnload
  viewWillAppear:
  viewDidAppear:
  shouldAutorotateToInterfaceOrientation:
  didReceiveMemoryWarning

####Adding a view to the view controller

  class MyViewController <UIViewController
    def loadView
      self.view = UIImageView.alloc.init
    end
    
    def viewDidLoad
      view.image = UIImage.imagedNamed('background.png')
    end
  end

#### Views
Views can have other nested subviews in a tree like structure.

Add the label as a subview of the image view.

First we need to create a label frame for our label:

  lableFrame = CGRectMake(x, y, width, hight)

RubyMotion give you access to all the `C` functions on the object class.
`CGRectMake` is a function on the object.

We can then create our label with:

  lableFrame = CGRectMake(10, 60, 300, 80)
  @label = UILable.alloc.initWithFrame(labelFrame)
  
But there is a shortcut to do this:

  labelFrame = [[10, 60], [300,80]]

Now add the subview label:

  class MyViewController <UIViewController
    def loadView
      self.view = UIImageView.alloc.init
    end
    
    def viewDidLoad
      view.image = UIImage.imagedNamed('background.png')
      @label = UILable.alloc.initWithFrame([[10, 60], [300,80]])
      view.addSubview(@label)
    end
  end

#### Refactor

Refactor the label out of the `viewDidLoad` method:

  def makeLabel
    label = UILabel.alloc.initWithFrame([[10, 60], [300, 80]])
    label.backgroundColor = UIColor.lightGrayColor
    label.text = "Tap for Answer!"
    label.font = UIFont.boldSystemFontOfSize(34)
    label.textColor = UIFont.darkGrayColor
    lable.testAlignment = UITextAlignmentCenter
    label
  end


### Interaction
We want to tap on an image view to enable us to change our own text.

Add a *gesture recognizer* to the image view that will send a message
(action) to the view controller (target).

Objective-C code:

  UiTapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] 
    initWithTarget:self
        action:@selector(showAnswer)];
    
`@selector(showAnswer)` will call the `showAnswer` method, `@selector`
allows you to call methods dynamically in Objective-C.

RubyMotion version:

  recogniser = UITapGestureRecognizer.alloc.initWithTarget(self,
action:'showAnswer')

You will also need to enable user interaction and then add this gesture
to the view, thus:

  view.userInteractinEnabled = true
  recognizer = UITapGestureRecognizer.alloc.initWithTarget(self,
action:'showAnswer')
  view.addGestureRecognizer(recognizer)

Now define your `showAnswer` method:

  def showAnswer
    @label.text = ['yes', 'no', 'maybe', 'try again'].sample
  end




### Block syntax for animating

Objective-C UIView class method for animating:

  + (void)animatedWithDuration:(NSTimeInterval)duration
            animations:(void (^)(void))animations

Called with:

  [UIView animatedWithDuration:1.0
          animations:^(
            @label.alpha = 1
          )];

The RubyMotion version:

  UIView.animatedWithDuration(1.0, 
    animations:lambda{
      @label.alpha = 1
    })

You can also add a completion block which will be executed on completion
of the animation:


  UIView.animatedWithDuration(1.0, 
    animations:lambda{
      @label.alpha = 0
    },
    completion:lambda{
      @label.text = "some value"
      @label.alpha = 1.0
    })

## Tips

In RubyMotion `Object` is an alias of `NSObject`, thus making `NSObject`
the root class of all Ruby classes.



## Links

**RubyMotion**  

* <http://www.rubymotion.com/developer-center/>
* <http://www.rubymotion.com/developer-center/guides/runtime/>
* <http://pragmaticstudio.com/screencasts/rubymotion>
* <https://github.com/mattetti/BubbleWrap>
* <http://malkomalko.github.com/motion-layouts/>
* [Submitting RubyMotion
  Apps](http://iconoclastlabs.com/cms/blog/posts/submitting-rubymotion-apps-to-the-app-store)
* [Rounded
  Corners](http://bradylove.com/blog/2012/06/04/rounded-corners-with-ruby-motion/)
* [Gesture painting
  example](http://collectiveidea.com/blog/archives/2012/06/06/getting-artistic-w-rubymotion/)

**General**  

* <http://developer.apple.com/library/ios/#documentation/cocoa/conceptual/objectivec/Chapters/ocObjectsClasses.html#//apple_ref/doc/uid/TP30001163-CH11-SW5>
* <http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CocoaFundamentals/Introduction/Introduction.html#//apple_ref/doc/uid/TP40002974-CH1-SW1>
* <http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/ObjC_classic/_index.html>
* <http://cocoadevcentral.com/d/learn_cocoa_two/>
* <http://cocoawithlove.com/2009/06/method-names-in-objective-c.html>

* <http://merbist.com/2012/05/04/macruby-on-ios-rubymotion-review/>
* <http://cocoadevcentral.com/d/learn_cocoa_two/>
* [RubyMotion & interface
  builder](http://ianp.org/2012/05/07/rubymotion-and-interface-builder/)
* [parse.com and
  rubymotion](http://collectiveidea.com/blog/archives/2012/05/21/using-rubymotion-with-parsecom/)
* [Storyboards](http://www.freelancemadscience.com/fmslabs_blog/2012/5/17/rubymotion-and-storyboards-two-great-tastes-that-taste-great.html)
* [Sugar-Cube wrapper over
  Obj-C](http://fusionbox.org/projects/rubymotion-sugarcube/)
* [iPhone settings using
  RubyMotion](https://github.com/mordaroso/rubymotion-settings)
* [Key-Value
  library](https://github.com/dreimannzelt/motion-kvo#key-value-observing-for-rubymotion)
 

**Cocoa iOS Examples**  

* <http://www.cimgf.com/2008/10/01/cocoa-touch-tutorial-iphone-application-example/>
















