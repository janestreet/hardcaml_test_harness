open! Core
open Hardcaml
open Hardcaml_step_testbench

module Make (I : Interface.S) (O : Interface.S) = struct
  module Sim = Cyclesim.With_interface (I) (O)
  module Step = Imperative.Cyclesim

  let run_advanced
    ?(here = Stdlib.Lexing.dummy_pos)
    ?(waves_config : Waves_config.t option)
    ?random_initial_state
    ?trace
    ?handle_multiple_waveforms_with_same_test_name
    ?test_name
    ?print_waves_after_test
    ~create
    testbench
    =
    Harness_base.run
      ~here
      ?waves_config
      ?random_initial_state
      ?trace
      ?handle_multiple_waveforms_with_same_test_name
      ?test_name
      ?print_waves_after_test
      ~cycle_fn:Cyclesim.cycle
      ~create:(fun ~always_wrap_waveterm ~wave_mode config scope ->
        let inst = create scope in
        let simulator = Sim.create ~config inst in
        Common.cyclesim_maybe_wrap_waves ~always_wrap_waveterm ~wave_mode simulator)
      (fun simulator ->
        Step.run_until_finished ~simulator ~testbench:(fun _ -> testbench simulator) ())
  ;;

  let run
    ?(here = Stdlib.Lexing.dummy_pos)
    ?waves_config
    ?random_initial_state
    ?trace
    ?handle_multiple_waveforms_with_same_test_name
    ?test_name
    ?print_waves_after_test
    ~create
    testbench
    =
    run_advanced
      ~here
      ?waves_config
      ?random_initial_state
      ?handle_multiple_waveforms_with_same_test_name
      ?trace
      ?test_name
      ?print_waves_after_test
      ~create
      (fun simulator ->
         let inputs = Cyclesim.inputs simulator in
         let outputs = Cyclesim.outputs simulator in
         testbench ~inputs ~outputs)
  ;;
end
