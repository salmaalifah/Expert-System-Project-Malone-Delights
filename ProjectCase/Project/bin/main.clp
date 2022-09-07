(deffunction cls ()
	(for (bind ?i 0) (< ?i 32) (++ ?i)
        (printout t crlf)
    )
)

(deffunction menu ()
    (printout t "=================================" crlf)
    (printout t "|         MALONE DELIGHTS       |" crlf)
    (printout t "=================================" crlf)
	(printout t "| 1. View Foods                 |" crlf)
    (printout t "| 2. Add Food                   |" crlf)
    (printout t "| 3. Update Food                |" crlf)
    (printout t "| 4. Delete Food                |" crlf)
    (printout t "| 5. Food Planning Consultation |" crlf)
    (printout t "| 6. Exit                       |" crlf)
    (printout t "=================================" crlf)
    
)

(deffunction subMenu ()
    (bind ?choice2 -1)
    (cls)
    (printout t "Categories to Choose" crlf)
    (printout t "--------------------" crlf)
    (printout t "1. Food" crlf)
    (printout t "2. Food Plans" crlf)
    (while (or(< ?choice2 0) (> ?choice2 2))
    	(printout t "Choose [1..2 |0 to go back to main menu]: ")
        (try 
        	(bind ?choice2 (integer(read)))
        catch (bind ?choice2 -1)
    	)   
    )
    (return ?choice2)
)

(deftemplate food
    (slot nameF)
    (slot rating)    
    (slot typeF)
    (slot priceF)
)

(deftemplate foodPlan
    (slot nameFP)
    (slot duration)    
    (slot priceFP)
    (slot foodName)
    (slot quantity)
)

(deffacts insert-food
    (food (nameF "Tomato Salsa") (rating 5.0) (typeF "Mexican") (priceF 5.00))
    (food (nameF "Margherita Pizza") (rating 4.7) (typeF "Italian") (priceF 20.00))
    (food (nameF "Szechwan Chili Chicken") (rating 4.0) (typeF "Chinese") (priceF 2.00))
    (food (nameF "Stir Fried Tofu With Rice") (rating 4.9) (typeF "Chinese") (priceF 4.00))
    (food (nameF "Pork Fried Rice") (rating 4.2) (typeF "Chinese") (priceF 7.50))
	(food (nameF "Pasta Carbonara") (rating 5.0) (typeF "Italian") (priceF 15.00))
    (food (nameF "Chicken Quesadillas") (rating 4.5) (typeF "Mexican") (priceF 8.00))      
)

(deffacts insert-foodPlan
    (foodPlan (nameFP "Rice Tofu Package") (duration 365) (priceFP 16685.71) (foodName "Stir Fried Tofu with Rice") (quantity 100))
	(foodPlan (nameFP "Salsa Package") (duration 120) (priceFP 34285.71) (foodName "Tomato Salsa") (quantity 500))
    (foodPlan (nameFP "Pizza Package") (duration 300) (priceFP 137142.85) (foodName "Margherita Pizza") (quantity 200))
)

(reset)

(defglobal 
    ?*current_totalFood* = 7
    ?*current_totalFoodPlan* = 3
    ?*cekfood* = ""
    ?*cekprice* = -1.0
    ?*pw* = -1.0
    ?*p* = -1.0
    ?*q* = ""
    ?*pricef* = -1.0
)

(defrule do-print-food
    (print-food)
    ?id <- (food (nameF ?name) (rating ?rating) (typeF ?type) (priceF ?price))
    =>
    (printout t (format nil "| %10s | %25s | %10.2f | %10s | $%10.2f |" ?id ?name ?rating ?type ?price) crlf) 
)

(defrule done-print-food
    ?id <- (done-foodprint)
	?factId <- (print-food)
    =>
    (retract ?factId)    
    (retract ?id)
)

(defrule do-print-foodPlan
    (print-foodPlan)
    ?id <- (foodPlan (nameFP ?nameFP) (duration ?duration) (priceFP ?priceFP) (foodName ?foodName) (quantity ?quantity))
    =>
    (printout t (format nil "| %10s | %25s | %10.2d |  %25s | %10.2d | $%15f |" ?id ?nameFP ?duration ?foodName ?quantity ?priceFP) crlf) 
)

(defrule done-print-foodPlan
    ?id <- (done-foodPlanprint)
	?factId <- (print-foodPlan)
    =>
    (retract ?factId)    
    (retract ?id)
)

(deffunction viewFood ()
    (printout t crlf "FOOD LIST" crlf)
  	(printout t "==================================================================================" crlf)
    (printout t (format nil "| %10s | %25s | %10s | %10s | %11s |" "No" "Nama" "Rating" "Type" "Price" )crlf) 
    (printout t "==================================================================================" crlf)
    (assert (print-food))
    (run)
    (assert (done-foodprint))
    (run)
    (printout t "==================================================================================" crlf)
)

(deffunction viewFoodPlan ()
    (printout t crlf "PLAN LIST" crlf)
  	(printout t "====================================================================================================================" crlf)
	(printout t (format nil "| %10s | %25s | %10s | %25s  | %10s | %16s |" "No" "Plan Name" "Duration" "Food Name" "Quantity" "Price" ) crlf) 
    (printout t "====================================================================================================================" crlf)
    (assert (print-foodPlan))
    (run)
    (assert (done-foodPlanprint))
    (run)
    (printout t "====================================================================================================================" crlf)
)

(deffunction addFood ()
	(bind ?nameF "")
    (bind ?rating -1)
    (bind ?typeF "")
    (bind ?priceF 0.0)
  
    ;name food
	(while(or (<(str-length ?nameF) 5) (>(str-length ?nameF) 28))
        (printout t "Input new Foods name [5 - 28 Characters]: ")
        (bind ?nameF (readline))
        (if (eq(regexp "[a-zA-Z ]+" ?nameF) FALSE) then
           	(bind ?nameF "")
        )
	)	
    
 	;rating food
	(while (or(< ?rating 0.0) (> ?rating 5.0))
        (printout t "Input new Foods rating [0.0 - 5.0 stars]: ")
        (bind ?rating (read))
        
        (if (eq(floatp ?rating) FALSE) then
            (bind ?rating -1)
            (printout t "Input must be a float" crlf)
        )
	)
    
    ;type food
    (while (and (and (neq ?typeF "Italian") 
                (neq ?typeF "Chinese"))
            	(neq ?typeF "Mexican"))
        
        (printout t "Input new Foods type [Italian | Chinese | Mexican] : ")
        (bind ?typeF (readline))
    ) 
    
    ;price food
    ;italian
    (if (eq ?typeF "Italian")
        then
    	(while (or (< ?priceF 15.0) (> ?priceF 80.0))
        	(printout t "Food Price [15.0 - 80.0]: $")
        	(bind ?priceF (read))
        
        	(if (eq(floatp ?priceF)FALSE) then
            	(bind ?priceF -1)
            	(printout t "Input must be a float" crlf)
            )
        )
     )    
    ;chinese
    (if (eq ?typeF "Chinese")
        then
    	(while (or (< ?priceF 1.50) (> ?priceF 20.0))
        	(printout t "Food Price [1.50 - 20.0]: $")
        	(bind ?priceF (read))
        
        	(if (eq(floatp ?priceF)FALSE) then
            	(bind ?priceF -1)
            	(printout t "Input must be a float" crlf)
            )
        )
     )
    
    ;Mexican
    (if (eq ?typeF "Mexican")
        then
    	(while (or (< ?priceF 5.0) (> ?priceF 25.0))
        	(printout t "Food Price [5.0 - 25.0]: $")
        	(bind ?priceF (read))
        
        	(if (eq(floatp ?priceF)FALSE) then
            	(bind ?priceF -1)
            	(printout t "Input must be a float" crlf)
            )
        )
    )
    
    (assert (food (nameF ?nameF) (rating ?rating) (typeF ?typeF) (priceF ?priceF)))
	(printout t ?nameF " Succesfully added!")
    (++ ?*current_totalFood*)

    (readline)
)

(defrule cek-food
    (cekFood ?cf)
    (not (food (nameF ?cf)))
    =>
    (bind ?*cekfood* "")
)

(defrule done-cek-food
    ?id <- (done-cekFood)
	?factId <- (cekFood ?*cekfood*)
    =>
    (retract ?factId)    
    (retract ?id)
)

(defrule cek-price
    (cekPrice ?cp)
    (food (nameF ?cp)(priceF ?p))
    =>
    (bind ?*cekprice* ?p)
)

(defrule done-cek-price
    ?id <- (done-cekPrice)
	?factId <- (cekPrice ?*cekprice*)
    =>
    (retract ?factId)    
    (retract ?id)
)

(deffunction addFoodPlan ()
    (bind ?nameFP "")
    (bind ?duration -1)    
    (bind ?priceFP -1.0)
    (bind ?foodName "")
    (bind ?quantity -1)
    
    
    ;name food plan
	(while(or (<(str-length ?nameFP) 1) (>(str-length ?nameFP) 20))
        (printout t "Input new plans name [Must end with 'Plan' | < 20 Characters]: ")
        (bind ?nameFP (readline))
        (if (eq(regexp "[a-zA-Z ]+Plan" ?nameFP) FALSE) then
           	(bind ?nameFP "")
        )
	)
    
    ;duration food plan
	(while (or(< ?duration 10) (> ?duration 3650))
        (printout t "Input new plans duration [10 days to 10 years | Insert in days]: ")
        (bind ?duration (read))
        
        (if (eq(integerp ?duration) FALSE) then
            (bind ?duration -1)
            (printout t "Input must be a integer" crlf)
        )
	)
    
    ;food name
    (viewFood)
    (while (<(str-length ?foodName) 1)
        (bind ?*cekfood* "")
        (printout t "Input a Food for this plan: ")
        (bind ?*cekfood* (readline))
        (assert (cekFood ?*cekfood*))
    	(run)
    	(assert (done-cekFood))
    	(run)
        (if (>(str-length ?*cekfood*) 1) then
            (bind ?foodName ?*cekfood*)
        )
	)
    
    ;food quantity
	(while (< ?quantity 10)
        (printout t "Input Food quantity distributed per week [> 10 portion]: ")
        (bind ?quantity (read))
        
        (if (eq(integerp ?quantity) FALSE) then
            (bind ?quantity -1)
            (printout t "Input must be a integer" crlf)
        )
	)
    
    (assert (cekPrice ?foodName))
    (run)
    (assert (done-cekPrice))
    (run)
    (bind ?priceFP (* (* (* ?*cekprice* 0.8) (/ ?duration 7)) ?quantity))
	(printout t "This plans total price is $"?priceFP crlf)
    
    (assert (foodPlan (nameFP ?nameFP) (duration ?duration) (priceFP ?priceFP) (foodName ?foodName) (quantity ?quantity)))
    (printout t ?nameFP " Succesfully added!" crlf)
    (++ ?*current_totalFoodPlan*)
    (readline)
)

(deffunction updateFood ()
    (viewFood)
    (bind ?fact_id -1)
    ;(while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFood*))
    (while (< ?fact_id 0 )
    	(printout t "Input number to be updated : ") 
    	(bind ?fact_id(read))
    	 (if (eq(integerp ?fact_id) FALSE) then
            (bind ?fact_id -1)
        )
    )
    
    (try
	    (bind ?nameF "")
    	(bind ?rating -1)
   		(bind ?typeF "")
    	(bind ?priceF 0.0)
  
    	;name food
		(while(or (<(str-length ?nameF) 5) (>(str-length ?nameF) 28))
        	(printout t "Input new Foods name [5 - 28 Characters]: ")
        	(bind ?nameF (readline))
        	(if (eq(regexp "[a-zA-Z ]+" ?nameF) FALSE) then
           		(bind ?nameF "")
        	)
		)	
    
 		;rating food
		(while (or(< ?rating 0.0) (> ?rating 5.0))
        	(printout t "Input new Foods rating [0.0 - 5.0 stars]: ")
        	(bind ?rating (read))
        
        	(if (eq(floatp ?rating) FALSE) then
            	(bind ?rating -1)
            	(printout t "Input must be a float" crlf)
        	)
		)
    
    	;type food
    	(while (and (and (neq ?typeF "Italian") 
                (neq ?typeF "Chinese"))
            	(neq ?typeF "Mexican"))
        
        	(printout t "Input new Foods type [Italian | Chinese | Mexican] : ")
        	(bind ?typeF (readline))
    	) 
    
    	;price food
    	;italian
    	(if (eq ?typeF "Italian")
        	then
    		(while (or (< ?priceF 15.0) (> ?priceF 80.0))
        		(printout t "Food Price [15.0 - 80.0]: $")
        		(bind ?priceF (read))
        
        		(if (eq(floatp ?priceF)FALSE) then
            		(bind ?priceF -1)
            		(printout t "Input must be a float" crlf)
            	)
        	)
     	)    
    	;chinese
    	(if (eq ?typeF "Chinese")
        	then
    		(while (or (< ?priceF 1.50) (> ?priceF 20.0))
        		(printout t "Food Price [1.50 - 20.0]: $")
        		(bind ?priceF (read))
        
        		(if (eq(floatp ?priceF)FALSE) then
            		(bind ?priceF -1)
            		(printout t "Input must be a float" crlf)
            	)
        	)
     	)
    
    	;Mexican
    	(if (eq ?typeF "Mexican")
        	then
    		(while (or (< ?priceF 5.0) (> ?priceF 25.0))
        		(printout t "Food Price [5.0 - 25.0]: $")
        		(bind ?priceF (read))
        
        		(if (eq(floatp ?priceF)FALSE) then
            		(bind ?priceF -1)
            		(printout t "Input must be a float" crlf)
            	)
        	)
    	)
           
        (modify ?fact_id (nameF ?nameF) (rating ?rating) (typeF ?typeF) (priceF ?priceF))
        (printout t "Update Succesful!")
                
     catch
        (printout t "Item not found ...")
    )
    
    (readline)
)

(deffunction updateFoodPlan ()
    (viewFoodPlan)
    (bind ?fact_id -1)
    ;(while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFoodPlan*))
    (while (< ?fact_id 0 )
    	(printout t "Input number to be updated : ") 
    	(bind ?fact_id(read))
    	(if (eq(integerp ?fact_id) FALSE) then
            (bind ?fact_id -1)
        )
    )
            
	(try
		(bind ?nameFP "")
    	(bind ?duration -1)    
    	(bind ?priceFP -1.0)
    	(bind ?foodName "")
    	(bind ?quantity -1)
        
    	;name food plan
		(while(or (<(str-length ?nameFP) 1) (>(str-length ?nameFP) 20))
        	(printout t "Input new plans name [Must end with 'Plan' | < 20 Characters]: ")
        	(bind ?nameFP (readline))
        	(if (eq(regexp "[a-zA-Z ]+Plan" ?nameFP) FALSE) then
           		(bind ?nameFP "")
        	)
		)
    
    	;duration food plan
		(while (or(< ?duration 10) (> ?duration 3650))
        	(printout t "Input new plans duration [10 days to 10 years | Insert in days]: ")
        	(bind ?duration (read))
        
        	(if (eq(integerp ?duration) FALSE) then
            	(bind ?duration -1)
            	(printout t "Input must be a integer" crlf)
        	)
		)
    
    	;food name
    	(viewFood)
    	(while (<(str-length ?foodName) 1)
        	(bind ?*cekfood* "")
        	(printout t "Input a Food for this plan: ")
        	(bind ?*cekfood* (readline))
        	(assert (cekFood ?*cekfood*))
    		(run)
    		(assert (done-cekFood))
    		(run)
        	(if (>(str-length ?*cekfood*) 1) then
            	(bind ?foodName ?*cekfood*)
        	)
		)
    
    	;food quantity
		(while (< ?quantity 10)
        	(printout t "Input Food quantity distributed per week [> 10 portion]: ")
        	(bind ?quantity (read))
        
        	(if (eq(integerp ?quantity) FALSE) then
            	(bind ?quantity -1)
            	(printout t "Input must be a integer" crlf)
        	)
		)
    
    	(assert (cekPrice ?foodName))
    	(run)
    	(assert (done-cekPrice))
    	(run)
    	(bind ?priceFP (* (* (* ?*cekprice* 0.8) (/ ?duration 7)) ?quantity))
		(printout t "This plans total price is $"?priceFP crlf)
    
    	(modify ?fact_id (nameFP ?nameFP) (duration ?duration) (priceFP ?priceFP) (foodName ?foodName) (quantity ?quantity))
        (printout t "Update Succesful!")
     catch
        (printout t "Item not found ...")
    )
    
    (readline)
)

(deffunction deleteFood ()
	(viewFood)
    (bind ?fact_id -1)
    ;(while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFood*))
    (while (< ?fact_id 0 )
    	(printout t "Item number to be deleted : ") 
    	(bind ?fact_id(read))
        (if (eq(integerp ?fact_id) FALSE) then
            (bind ?fact_id -1)
        )
    )
    
    (try
        (fact-id ?fact_id)
        (retract ?fact_id )   
        (printout t "Delete Succesful!")
    catch
        (printout t "Food not found" crlf)
    )
    
    (readline)
)

(deffunction deleteFoodPlan ()
	(viewFoodPlan)
    (bind ?fact_id -1)
    ;(while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFoodPlan*))
   	(while (< ?fact_id 0 )
    	(printout t "Item number to be deleted : ") 
    	(bind ?fact_id(read))
        (if (eq(integerp ?fact_id) FALSE) then
            (bind ?fact_id -1)
        )
    )
    
    (try
        (fact-id ?fact_id)
        (retract ?fact_id )   
        (printout t "Delete Succesful!")
    catch
        (printout t "Food not found" crlf)
    )
    (readline)
)


(deftemplate question
    (slot id)
    (slot text)
)

(deftemplate ask
    (slot id)
	(slot question)
)

(deftemplate answer
    (slot id)
    (slot ans)
)

(deftemplate solution
    (slot text)
)

;food
(defrule init1
    (init1-ask)
    =>
	(assert (ask (id 4) (question "Tell us the quality of the food you need..")))
)

(defrule ask-question-4
    (ask (id 4) (question ?ques))
    (not (answer (id 4)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and(and (neq (str-compare ?answer "High") 0)
            	(neq (str-compare ?answer "Moderate") 0)))
        do
        (printout t "High or Moderate?" crlf)
        (bind ?answer (readline))
    )
    (assert (answer (id 4) (ans ?answer)))
)

(defrule answer-4-high
    (answer (id 4) (ans "High"))
    =>
    (assert (ask (id 5) (question "Do you need foods for official purpose?")))
)

(defrule ask-question-5
    (ask (id 5) (question ?ques))
    (not (answer (id 5)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and(and (neq (str-compare ?answer "Yes") 0)
            	(neq (str-compare ?answer "No") 0)))
        do
        (printout t "[Yes or No] :")
        (bind ?answer (readline))
    )
    (assert (answer (id 5) (ans ?answer)))
)

(defrule answer-5-yes
    (answer (id 5) (ans "Yes"))
    =>
    (assert (ask (id 6) (question "Are you open to other options of Food besides normal?")))
)

(defrule ask-question-6
    (ask (id 6) (question ?ques))
    (not (answer (id 6)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and(and (neq (str-compare ?answer "Yes") 0)
            	(neq (str-compare ?answer "No") 0)))
        do
        (printout t "[Yes or No] :")
        (bind ?answer (readline))
    )
    (assert (answer (id 6) (ans ?answer)))
)

(defrule answer-6-yes
    (answer (id 6) (ans "Yes"))
    =>
    (printout t "all" crlf)
)

(defrule answer-6-no
    (answer (id 6) (ans "No"))
    =>
    (printout t "italian" crlf)
)

(defrule answer-5-no
    (answer (id 5) (ans "No"))
    =>
    (assert (ask (id 7) (question "Tell us your budget scale..")))
)

(defrule ask-question-7
    (ask (id 7) (question ?ques))
    (not (answer (id 7)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and(and (neq (str-compare ?answer "Unlimited") 0)
            	(neq (str-compare ?answer "High") 0)
                (neq (str-compare ?answer "Low") 0)))
        do
        (printout t "[Low | High | Unlimited]: ")
        (bind ?answer (readline))
    )
    (assert (answer (id 7) (ans ?answer)))
)

(defrule answer-7-unlimited
    (answer (id 7) (ans "Unlimited"))
    =>
    (bind ?*pricef* 9999999999999999999.0)
)

(defrule answer-7-high
    (answer (id 7) (ans "High"))
    =>
    (bind ?*pricef* 100.0)
)

(defrule answer-7-low
    (answer (id 7) (ans "Low"))
    =>
    (bind ?*pricef* 4.0)
)

(defrule answer-4-moderate
    (answer (id 4) (ans "Moderate"))
    =>
    (assert (ask (id 8) (question "Tell us your budget scale..")))
)

(defrule ask-question-8
    (ask (id 8) (question ?ques))
    (not (answer (id 8)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and(and (neq (str-compare ?answer "Unlimited") 0)
            	(neq (str-compare ?answer "High") 0)
                (neq (str-compare ?answer "Low") 0)))
        do
        (printout t "[Low | High | Unlimited]: ")
        (bind ?answer (readline))
    )
    (assert (answer (id 8) (ans ?answer)))
)

(defrule answer-8-unlimited
    (answer (id 8) (ans "Unlimited"))
    =>
    (bind ?*pricef* 999999999999999999.0)
)

(defrule answer-8-high
    (answer (id 8) (ans "High"))
    =>
    (bind ?*pricef* 15.0)
)

(defrule answer-8-low
    (answer (id 8) (ans "Low"))
    =>
    (bind ?*pricef* 3.0)
)

(defquery query-food
    (food (nameF ?nameF) (rating ?rating) (typeF ?typeF) (priceF ?priceF))
    (test (< ?priceF ?*pricef*))
)

;foodPlan
(defrule init
    (init-ask)
    =>
	(assert (ask (id 1) (question "Tell us how big are your needs..")))
)

(defrule ask-question-1
    (ask (id 1) (question ?ques))
    (not (answer (id 1)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and(and (neq (str-compare ?answer "Personal Purposes") 0)
            	(neq (str-compare ?answer "Small Scale") 0))
            	(neq (str-compare ?answer "Large Scale") 0))
        do
        (printout t "[Personal Purposes | Small Scale | Large Scale] : ")
        (bind ?answer (readline))
    )
    (assert (answer (id 1) (ans ?answer)))
)

(defrule answer-1-personal
    (answer (id 1) (ans "Personal Purposes"))
    =>
    (bind ?*pw* 50.0)
    (assert (ask (id 2) (question "Tell us your budget scale..")))
)

(defrule answer-1-small
    (answer (id 1) (ans "Small Scale"))
    =>
    (bind ?*pw* 1000.0)
    (assert (ask (id 2) (question "Tell us your budget scale..")))
)

(defrule answer-1-large
    (answer (id 1) (ans "Large Scale"))
    =>
    (bind ?*pw* 5000.0)
    (assert (ask (id 2) (question "Tell us your budget scale..")))
)

(defrule ask-question-2
    (ask (id 2) (question ?ques))
    (not (answer (id 2)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and(and(and (neq (str-compare ?answer "Small") 0)
            	(neq (str-compare ?answer "Medium") 0))
            	(neq (str-compare ?answer "Large") 0))
            	(neq (str-compare ?answer "Unlimited") 0))
        do
        (printout t "Your budget scale [Small | Medium | Large | Unlimited]: ")
        (bind ?answer (readline))
    )
    (assert (answer (id 2) (ans ?answer)))
)

(defrule answer-2-small
    (answer (id 2) (ans "Small"))
    =>
    (bind ?*p* 10000.0)
    (assert (ask (id 3) (question "Choose the quality of Food..")))
)

(defrule answer-2-medium
    (answer (id 2) (ans "Medium"))
    =>
    (bind ?*p* 50000.0)
    (assert (ask (id 3) (question "Choose the quality of Food..")))
)

(defrule answer-2-large
    (answer (id 2) (ans "Large"))
    =>
    (bind ?*p* 100000.0)
    (assert (ask (id 3) (question "Choose the quality of Food..")))
)

(defrule answer-2-unlimited
    (answer (id 2) (ans "Unlimited"))
    =>
    (bind ?*p* 999999999999999999999999999999999999999.0)
    (assert (ask (id 3) (question "Choose the quality of Food..")))
)

(defrule ask-question-3
    (ask (id 3) (question ?ques))
    (not (answer (id 3)))
    =>
    (printout t ?ques crlf)
    (bind ?answer "")
    (while (and (neq (str-compare ?answer "High") 0)
            	(neq (str-compare ?answer "Moderate") 0))
        do
        (printout t "Your Food quality [High | Moderate]: ")
        (bind ?answer (readline))
    )
    (assert (answer (id 3) (ans ?answer)))
)

(defrule answer-3-high
    (answer (id 3) (ans "High"))
    =>
    (bind ?*q* "high")
)

(defrule answer-3-moderate
    (answer (id 3) (ans "Moderate"))
    =>
    (bind ?*q* "moderate")
)

(defquery query-foodplan
    (foodPlan (nameFP ?nameFP) (duration ?duration) (priceFP ?priceFP&:(< ?priceFP ?*p*)) (foodName ?foodName) (quantity ?quantity))
    (test (< (/ ?quantity (/ ?duration 7.0) ?*pw*)))
)

(bind ?choice 0)
(bind ?choice2 -1)
(while (neq ?choice 6)
    (bind ?choice 0)
    (cls)
    (menu)
    (while (or(< ?choice 1) (> ?choice 6))
        (printout t "Choose [1..6]: ")
    	(try 
        	(bind ?choice (integer(read)))
        catch (bind ?choice -1)
    	)
    )
    
    (if (eq ?choice 1)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(viewFood)
            
         elif(eq ?choice2 2)
            then
            (viewFoodPlan)
        )
        (if (neq ?choice2 0)
            then
        	(printout t "Press ENTER to back to main menu...")
        	(readline)
        )
        
     elif (eq ?choice 2)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(addFood)
            
         elif(eq ?choice2 2)
            then
            (addFoodPlan)
        )        
        
     elif (eq ?choice 3)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(updateFood)
            
         elif(eq ?choice2 2)
            then
            (updateFoodPlan)
        )
        
     elif (eq ?choice 4)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(deleteFood)
            
         elif(eq ?choice2 2)
            then
            (deleteFoodPlan)
        )

     elif (eq ?choice 5)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
            (assert (init1-ask))
    		(run)          
            
         elif(eq ?choice2 2)
            then
            (assert (init-ask))
    		(run)    
        )
        
        (new main.Template)
        (printout t "Press enter to continue...")
        (readline)
    )  
)

