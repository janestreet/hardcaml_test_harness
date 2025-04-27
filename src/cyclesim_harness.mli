open Hardcaml

module Make (I : Interface.S) (O : Interface.S) : sig
  val run
    : (create:(Scope.t -> Signal.t I.t -> Signal.t O.t)
       -> (inputs:Bits.t ref I.t
           -> outputs:Bits.t ref O.t
           -> (Bits.t ref I.t, Bits.t ref O.t) Cyclesim.t
           -> unit)
       -> unit)
        Harness_base.with_test_config
end
