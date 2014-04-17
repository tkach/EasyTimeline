EasyTimeline
============

Sometimes you need things to happen at specific times and things. 

When it's just an event 2.0 seconds later, a `performSelector:withObject:afterDelay:` is perfect. 

If it gets a little more complex where you need something happening ever 3.0 seconds, a quick implementation of `NSTimer` is good.

But what if you want something to happen every 2 seconds and then at the 7th second something else to happen. Or if you want to pause everything for a while and then resume later?

![Easy Timeline Example](http://mmislam101.github.io/easyTimeline/loop_timeline.png)

That's where **Easy Timeline** comes into play.

###Installation

You can install it via Cocoapods:

Add into your Podfile:

	pod 'EasyTimeline', :git => 'https://github.com/mmislam101/EasyTimeline'
And run

	pod update

Or you can just add EasyTimeline folder to your project.

###Setup

Init with: 
```smalltalk
EasyTimeline *timeline  = [[EasyTimeline alloc] init]
timeline.duration       = 10.0; // Duration is in seconds. You can even use fractional seconds, warning below
```

####Warning:
This is based on NSTImer which has a tolerance level. The [Apple's documenation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSTimer_Class/Reference/NSTimer.html) states:
>A timer is not a real-time mechanism; it fires only when one of the run loop modes to which the timer has been added is running and able to check if the timer’s firing time has passed. Because of the various input sources a typical run loop manages, the effective resolution of the time interval for a timer is limited to on the order of 50-100 milliseconds. If a timer’s firing time occurs during a long callout or while the run loop is in a mode that is not monitoring the timer, the timer does not fire until the next time the run loop checks the timer. Therefore, the actual time at which the timer fires potentially can be a significant period of time after the scheduled firing time.

You'll see if you run the example project in the output how much the tolerances are.

###Controls

Easy Timeline is controlled through the following function calls
```smalltalk
[timeline start]; // Starts and re-starts the timer
[timeline stop]; // Stops the timer and resets it
[timeline pause]; // Pauses the timer
[timeline resume]; // Resume after pausing
[timeline skipForwardSeconds:2.0]; // Skip forward specific seconds
```

You can also set the timeline to loop by setting the timeline's `willLoop` property to `YES`. By default this is set to `NO`

After starting Easy Timeline, you can't really change any of the properties and affect the timeline except for the tickPeriod property, and skipping. Below in the **Ticks** section there is more explanation. Any changes to other properties such as duration and time of events will not take effect unless you re-start the timeline with `[timeline start]`

###Completion

Easy Timeline provides the delegate function `(void)finishedTimeLine:(EasyTimeline *)timeline` as well as the block property `timelineCompletionBlock completionBlock` which you can set with a `^void (EasyTimeline *timeline)` type to execute code when the timeline completes.

```smalltalk

- (void)init
{
...
  EasyTimeline *timeline  	= [[EasyTimeline alloc] init]
  timeline.delegate			= self;
  timeline.duration       	= 10.0;
  
  timeline.completionBlock	= ^void (EasyTimeline *timeline) {
		NSLog(@"monkey");
	};
	
  [timeline start];
...
}

#pragma mark EasyTimelineDelegate

- (void)finishedTimeLine:(EasyTimeline *)timeline
{
	NSLog(@"butt");
}
```

This would produce the logs "monkey" and then "butt"

###Ticks

Settings the `NSTimeInterval tickPeriod` (as long as the period is less than the duration) will allow you to execute code in periodic timer intervals while Easy Timeline is running.

This is the only property that can be changed and will take effect *while* the timeline is running. There's an example in the example project to show this behavior.

Easy Timeline provides the delegate function `(void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline` as well as the block property `timelineTickBlock tickBlock` which you can set with a `^void (NSTimeInterval time, EasyTimeline *timeline)` type to execute code when the timeline completes.

```smalltalk
- (void)init
{
...
  EasyTimeline *timeline 	= [[EasyTimeline alloc] init]
  timeline.delegate			= self;
  timeline.duration       	= 10.0;
  timeline.tickPeriod	  	= 1.0;
  
  timeline.tickBlock	  	= ^void (NSTimeInterval time, EasyTimeline *timeline) {
		NSLog(@"block tick");
	};
	
  [timeline start];
...
}

#pragma mark EasyTimelineDelegate

- (void)tickAt:(NSTimeInterval)time forTimeline:(EasyTimeline *)timeline
{
	NSLog(@"delegate tick");
}
```

This would produce the logs "block tick" and then "delegate tick" periodically till the timeline finishes

###Events

Easy Timeline offers you an ability to add blocks of code to execute at a specific time within the running of the timeline.

Using the `EasyTimelineEvent` class you can set a time and a execution block and add it to the timeline.

```smalltalk
- (void)init
{
...
  EasyTimeline *timeline 	= [[EasyTimeline alloc] init]
  timeline.duration       	= 10.0;
  
  [timeline addEvent:[EasyTimelineEvent eventAtTime:3.0 WithCompletion:^(EasyTimelineEvent *event, EasyTimeline *timeline) {
	NSLog(@"event fired");
  }]];
	
  [timeline start];
...
}
```

will give you a log of "event fired" after 3.0 seconds
