import rm.objects.Game_Event;
import rm.objects.Game_Player;

enum abstract MoveEvents(String) from String to String {
  public var PLAYERMOVE = 'playerMove';
  public var EVENTMOVE = 'eventMove';
}

enum GameCharacter {
  Player(player: Game_Player);
  Event(event: Game_Event);
}
