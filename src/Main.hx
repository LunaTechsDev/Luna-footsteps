import Types.GameCharacter;
import rm.types.RM.AudioParameters;
import rm.managers.AudioManager;
import Types.MoveEvents;
import macros.FnMacros;
import pixi.interaction.EventEmitter;
import core.Amaryllis;
import utils.Comment;
import rm.Globals;
import rm.objects.Game_Character;

using Lambda;
using core.StringExtensions;
using core.NumberExtensions;
using StringTools;
using utils.Fn;

typedef LParams = {}

@:native('LunaFootsteps')
@:expose('LunaFootsteps')
class Main {
  public static var Params: LParams = null;
  public static var listener: EventEmitter = Amaryllis.createEventEmitter();
  public static var soundsDisabled: Bool;

  public static function main() {
    var plugin = Globals.Plugins.filter((plugin) -> ~/<LunaFootsteps>/ig.match(plugin.description))[0];
    var params = plugin.parameters;
    // untyped Params = {
    //   linkWindows: JsonEx.parse(params['linkWindows']).map((win) -> JsonEx.parse(win))
    // }
    trace(Params);

    Comment.title('Game_Character');
    FnMacros.jsPatch(true, Game_Character, CharacterPatch);

    setupEvents();
  }

  public static inline function setupEvents() {
    listener.on(MoveEvents.PLAYERMOVE, (player: GameCharacter) -> {
      var se = getSe(player);
      if (se != null && !soundsDisabled) {
        AudioManager.playSe(se);
      }
    });

    listener.on(MoveEvents.EVENTMOVE, (event: GameCharacter) -> {
      var se = getSe(event);
      if (se != null && !soundsDisabled) {
        AudioManager.playSe(se);
      }
    });
  }

  public static function getSe(char: GameCharacter): Null<AudioParameters> {
    var note = '';
    var re = ~/<lfse:(\w+)\s+(\d+)\s+(\d+)\s+(\d+)>/ig;

    switch (char) {
      case Player(player):
        note = Globals.GameParty.leader().actor().note;
      case Event(event):
        note = event.event().note;
    }
    // <lfse: fileName volume pitch pan >
    if (re.match(note)) {
      return {
        name: re.matched(1).trim(),
        volume: Fn.parseIntJs(re.matched(2).trim()),
        pitch: Fn.parseIntJs(re.matched(3).trim()),
        pan: Fn.parseIntJs(re.matched(4).trim()),
        pos: 0
      };
    } else {
      return null;
    }
  }

  public static function disableSounds() {
    soundsDisabled = true;
  }

  public static function enableSounds() {
    soundsDisabled = false;
  }
}
