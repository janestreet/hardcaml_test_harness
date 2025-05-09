open! Core
open Hardcaml
open Hardcaml_waveterm

(** Shared arguments that all variants of the harness should be taking *)
type 'a with_test_config =
  ?here:Stdlib.Lexing.position
  -> ?waves_config:Waves_config.t
       (** Configure waveform generation following the rules defined in Waves_config. *)
  -> ?random_initial_state:[ `All | `Mems | `Regs | `None ]
       (** If set to a value other than `None then the test simulation state will be
           randomized before the testbench is run.

           [`All] randomizes registers and memories.

           [`Mems] randomizes memories only.

           [`Regs] randomizes registers only. *)
  -> ?trace:[ `All_named | `Everything | `Ports_only ]
  -> ?handle_multiple_waveforms_with_same_test_name:[ `Save_all | `Save_last_only ]
       (** If multiple tests are run with the same test-name / line number, whether to
           save all of the waveforms (with indices added) or only save waves for the last
           test that runs. *)
  -> ?test_name:string
  -> ?print_waves_after_test:(Waveform.t -> unit)
  -> 'a

val run
  : (cycle_fn:('sim -> unit)
     -> create:
          (always_wrap_waveterm:bool
           -> wave_mode:Wave_mode.t
           -> Cyclesim.Config.t
           -> Scope.t
           -> 'sim * Waveform.t option)
     -> ('sim -> 'a)
     -> 'a)
      with_test_config
