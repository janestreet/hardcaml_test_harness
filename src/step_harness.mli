open Hardcaml
open Hardcaml_step_testbench

module Make (I : Interface.S) (O : Interface.S) : sig
  module Step : Functional.M(Functional.Cyclesim.Monads)(I)(O).S

  val run
    : (?input_default:Bits.t I.t (** Set the default input for the simulation. *)
       -> create:(Scope.t -> Signal.t I.t -> Signal.t O.t)
       -> (unit -> unit Step.t)
       -> unit)
        Harness_base.with_test_config
end
