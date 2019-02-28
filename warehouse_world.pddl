(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?r - robot ?ini - location ?tar - location)
      :precondition (and (at ?r ?ini) (connected ?ini ?tar) (no-robot ?tar))
      :effect (and (at ?r ?tar) (no-robot ?ini) (not (no-robot ?tar)) (not (at ?r ?ini)))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?ini - location ?tar - location ?p - pallette)
      :precondition (and (at ?r ?ini) (at ?p ?ini) (connected ?ini ?tar) (no-robot ?tar) (no-pallette ?tar))
      :effect (and (at ?r ?tar) (no-robot ?ini) (at ?p ?tar) (no-pallette ?ini) (not (at ?p ?ini)) (not (no-pallette ?tar)) (not (no-robot ?tar)) (not (at ?r ?ini)))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?si - saleitem ?p - pallette ?s - shipment ?o - order ?l - location)
      :precondition (and (at ?p ?l) (packing-at ?s ?l) (not (complete ?s)) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-at ?s ?l))
      :effect (and (complete ?s) (available ?l))
   )

)
