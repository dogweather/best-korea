@protocol RealityUpdateListener

// Receive the notification that our reality
// changed, and that I should update myself if
// I need to.
- (void) updateForNewReality;

@end