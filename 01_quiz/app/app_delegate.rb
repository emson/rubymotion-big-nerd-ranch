class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.redColor
    @window.rootViewController = QuizViewController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end
