import Types.MoveEvents;
import rm.objects.Game_Player;
import rm.objects.Game_Event;
import utils.Fn;
import rm.objects.Game_Character;
import Types.GameCharacter;

// ExecuteMove ? -> uses MoveStraight
// Events Follow Move Routes via processMovecommand
// Move Straight seems to be used for everything
class CharacterPatch extends Game_Character {
  public override function moveStraight(d: Int) {
    // super.moveStraight(d);
    if (Fn.instanceof(this, Game_Event)) {
      Main.listener.emit(MoveEvents.EVENTMOVE, Event(cast this));
    }

    if (Fn.instanceof(this, Game_Player)) {
      Main.listener.emit(MoveEvents.PLAYERMOVE, Player(cast this));
    }
    untyped _Game_Character_moveStraight.call(this, d);
  }
}
