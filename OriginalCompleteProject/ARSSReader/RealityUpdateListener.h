@protocol RealityUpdateListener

// Receive the notification that our reality
// changed, and I should update myself if
// necessary.
- (void) updateForNewReality;

@end