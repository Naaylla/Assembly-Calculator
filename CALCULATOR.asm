data segment 
          
    ;;;DATA;;;
    
    ;;;AFFICHAGE DU MENU;;; 
    
    MessageAccueil DB "Calculatrice developpee par R.Naila & D.Nada", 10, 13, "$";
    Message1 DB 10, 13, 10, 13, "Entrez le premier operande : ", "$";
    Message2 DB 10, 13, "Entrez le deuxieme operande : ", "$";   
    MessageFIN DB 10, 13, 10, 13, 10, 13, "Fin du programme. Merci.","$";
    
    ;Menu des modes
    
    Menu1 DB 10, 13, 10, 13,"Choisir le mode", 10, 13, 10, 13,"  '1' Pour Decimale", 10, 13,"  '2' Pour Binaire", 10, 13,"  '3' Pour Hexadecimal", 10, 13,"  'x' Exit", 10, 13, 10, 13,"   Votre choix : ","$";                   
    
    ;Menu des operations
       
    Menu2 DB 10, 13, 10, 13,"Choisir l'operation a executer", 10, 13, 10, 13,"  '+' Addition", 10, 13,"  '-' Soustraction", 10, 13,"  '/' Division", 10, 13,"  '*' Multiplication", 10, 13,"  'x' Exit", 10, 13, 10, 13,"  Votre choix : ","$";
    
    ;Le menu suivant est pour poursuivre le calcul avec le resultat precedent on a ajoute le choix "remettre a 0" 
    
    Menu3 DB 10, 13, 10, 13,"Choisir l'operation a executer", 10, 13, 10, 13,"  '+' Addition", 10, 13,"  '-' Soustraction", 10, 13,"  '/' Division", 10, 13,"  '*' Multiplication", 10, 13, "  '0' Pour remettre a 0", 10, 13,"  'x' Exit", 10, 13, 10, 13,"  Votre choix : ","$"; 
                
    ;Messages Additionels 
    
    MessageAlerte DB 10, 13, 10, 13, "Le resultat precedent a ete supprime", 10, 13, "$"; 
    Espace DB 10, 13, "$";
       
    ;;;OPERATIONS NECESSAIRES POUR l'AFFICHAGE;;; 
    
    Egal DB ' = $';
          
    ;;;AFFICHAGE MESSAGES TRAITEMENT DES ERREURS;;;
    
    ErreurIN DB 10, 13, 10, 13, "Entrez une valeur valide.", "$";
    Erreur0 DB 10, 13, 10, 13, "Erreur : Division par zero impossible.", "$";   
    ErreurOFR DB 10, 13, 10, 13, "Erreur OVERFLOW : Le resultat depasse la capacite maximale de la variable", "$";  
    ErreurOP1OP2 DB 10, 13, 10, 13, "Erreur saisi : l'operande 1 est inferieur a l'operande 2", "$";
    ErreurOF DB 10, 13, 10, 13, "Erreur OVERFLOW : la taille de l'operande depasse la capacite de la variable", "$"; 
    
    ;;;VARIABLES;;;  
    
    RESULT DW 0
    OPERATION DB 0
    MODE DB 0     
    BString DB 19 DUP(0) 
    DString DB 8 DUP(0)    
    HString DB 7 DUP(0)
    OP1 DW 0
    OP2 DW 0 
    
ends


code segment
start:       

    ;;;REGISTRE SEGMENTS;;; 
    
    MOV AX, data;
    MOV DS, AX;  
        
    ;;;CODE;;; 
        
    ;;;INTIALISATION DES REGISTRES ET VARIABLES;;; 
    
    CALL Init;    
         
    ;Affichage du premier message
      
    CALL Welcome;  
 
    
BOUCLE1: 

    ;Affichage du menu des modes 
                
    CALL ModeMenu;
     
    ;Lecture du choix de mode
       
    CALL ModeChoice;
     
    ;Sauter vers le mode voulu
     
    CALL goToMODE;           
                  
    ;Pour le cas ou l'utilisateur ne souhaite pas poursuivre avec le resultat precedent et souhaite remettre a 0 
                  
BOUCLE1_remis_a_0:  

    CALL AlerteMessage  
    CALL Boucle1repeat
        
    ;;;MODE DECIMALE;;:
                  
decimale: 
     
    ;Fonction qui affiche le menu des operations
     
    CALL OPMenu;        
    
    ;Fonction qui demande a l'utilisateur d'entrer une operation et la lis
    
    CALL OPChoice;                     

    ;Fonction qui mene vers l'operation voulu 
                                                          
    CALL DecimaleOP;   
    
    ;Pour poursuivre avec le resultat precedent
    
decimale_suite:
    
    ;Menu d'operations avec la possibilite de continuer avec le resultat precedent ou reset
     
    CALL OperationMenuSuite;  
     
    ;Lecture du choix de mode
       
    CALL OPChoice;  
         
    ;Sauter vers le mode voulu (mettre a 0 est une nouvelle option pour choisir entre finir avec le resultat precedent ou remettre a 0)
     
    CALL DecimaleOPsuite  
    
;;;;;;;;;;;;;;;;;;;;;;;;;;  

    ;Additioner en decimal avec le resultat precedent
      
ADDDsuite:  

    CALL LireOPERANDE2
    MOV AX, result   
    MOV OP1, AX 
    JMP IGNORE0
    
    ;Additioner en decimal
              
ADDD: 
 
    CALL LireOperandes  
    
IGNORE0:
      
    MOV AX,OP1 
    ADD AX, OP2
    MOV result,AX 
    JC ErreurOVERFLOWRESULT
    CALL Affiche
    JMP decimale_suite 
    
;;;;;;;;;;;;;;;;;;;;;;;;;; 
    
    ;Soustaire en decimal avec le resultat precedent
    
SUBDsuite:  
                                       
    CALL LireOPERANDE2 
    MOV AX, result   
    MOV OP1, AX  
    JMP IGNORE1
    
    ;Soustaire en decimal
    
SUBD:  
 
    CALL LireOperandes

IGNORE1:   
    
    MOV AX,OP1    
    CMP AX,OP2
    JL ErreurOP1LesserThanOP2 
    SUB AX, OP2 
    MOV result, AX
    JC ErreurOVERFLOWRESULT    
    CALL Affiche
    JMP decimale_suite
     
;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;Multiplier en decimal avec le resultat precedent
    
MULDsuite:

    CALL LireOPERANDE2  
    MOV AX, result   
    MOV OP1, AX  
    JMP IGNORE2 
     
    ;Multiplier en decimal
     
MULD:
 
    CALL LireOperandes 
     
IGNORE2: 
    
    MOV AX,OP1 
    MOV bx, OP2
    MUL bx         
    MOV RESULT, AX                                                     
    JC ErreurOVERFLOWRESULT 
    CALL Affiche
    JMP decimale_suite  
    
;;;;;;;;;;;;;;;;;;;;;;;;;; 
    
    ;Division en decimal avec le resultat precedent
    
DIVDsuite:

    CALL LireOPERANDE2
    MOV AX, result   
    MOV OP1, AX  
    JMP IGNORE4
    
    ;Division en decimal
      
DIVD:  

    CALL LireOperandes
      
IGNORE4:       

    MOV dx, 0
    MOV AX, OP1 
    MOV bx, OP2
    CMP bx, 0
    JZ ErreurZero 
    DIV bx
    MOV RESULT, AX 
    JC ErreurOVERFLOWRESULT  
    CALL Affiche
    JMP decimale_suite 
    
    ;;;MODE BINAIRE;;:    
         
binaire:        
     
    ;Fonction qui affiche le menu des operations
     
    CALL OPMenu;        
    
    ;Fonction qui lis l'operation choisis par l'utilisateur
    
    CALL OPChoice;
    
    ;Fonction qui mene vers l'operation voulu 
    
    CALL BinaireOP; 
        
    ;Pour poursuivre avec le resultat precedent
    
binaire_suite:
    
    ;Menu d'operations avec la possibilite de continuer avec le resultat precedent ou remettre a 0
     
    CALL OperationMenuSuite; 
     
    ;Lecture du choix de mode
       
    CALL OPChoice; 
         
    ;Sauter vers le mode voulu (mettre a 0 est une nouvelle option pour choisir entre finir avec le resultat precedent ou remettre a 0)
     
    CALL BinaireOPsuite 
    
;;;;;;;;;;;;;;;;;;;;;;;;;; 

ADDBSuite:

    CALL LireOPERANDE2B 
    MOV AX, result   
    MOV OP1, AX 
    JMP IGNORE5  
        
ADDB:    

    CALL LireOperandesB 
      
IGNORE5:

    MOV AX,OP1 
    ADD AX, OP2
    MOV result,AX 
    
    JC ErreurOVERFLOWRESULT 
    
    CALL AfficheB
    jmp binaire_suite 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;

SUBBsuite: 
   
    CALL LireOPERANDE2B  
    MOV AX, result   
    MOV OP1, AX 
    JMP IGNORE6 
      
SUBB: 
 
    CALL LireOperandesB 
    
IGNORE6:
 
    MOV AX, OP1
    SUB AX, OP2 
    MOV result, AX 
    
    JC ErreurOVERFLOWRESULT   
    
    CALL AfficheB 
    
    jmp binaire_suite  
    
;;;;;;;;;;;;;;;;;;;;;;;;;;   

MULBSuite: 
   
    CALL LireOPERANDE2B 
    MOV AX, result   
    MOV OP1, AX  
    JMP IGNORE7 
    
MULB:  

    CALL LireOperandesB 
    
IGNORE7:       
      
    MOV AX,OP1
    MOV bx,OP2
    MUL bx  
    
    MOV RESULT,AX 
    JC ErreurOVERFLOWRESULT
     
    CALL AfficheB
    
    jmp binaire_suite 
    
;;;;;;;;;;;;;;;;;;;;;;;;;; 
                   
DIVBSuite:
 
    CALL LireOPERANDE2B
    MOV AX, result   
    MOV OP1, AX   
    JMP IGNORE8 
    
DIVB: 
 
    CALL LireOperandesB  
    
IGNORE8:   
     
    MOV dx, 0
    MOV AX, OP1 
    MOV bx, OP2
    
    CMP bx, 0
    JZ ErreurZero 
    
    DIV bx
    MOV RESULT, AX 
    
    JC ErreurOVERFLOWRESULT  
    
    CALL AfficheB; 
    jmp binaire_suite
     
    ;;;MODE HEXADECIMALE;;:   
    
hexadecimale:   
            
    ;Fonction qui affiche le menu des operations
     
    CALL OPMenu;        
    
    ;Fonction qui lis l'operation choisis par l'utilisateur
    
    CALL OPChoice;  
    
    ;Fonction qui mene vers l'operation voulu 
  
    CALL HexadecimaleOP; 
    
    ;Pour poursuivre avec le resultat precedent 
    
Hexadecimale_suite:
    
    ;Menu d'operations avec la possibilite de continuer avec le resultat precedent
     
    CALL OperationMenuSuite; 
     
    ;Lecture du choix de mode
       
    CALL OPChoice;  
        
    ;Sauter vers le mode voulu (mettre a 0 est une nouvelle option pour choisir entre finir avec le resultat precedent ou remettre a 0)
     
    CALL HexadecimaleOPsuite    
    
;;;;;;;;;;;;;;;;;;;;;;;;;; 

ADDHXsuite:  

    CALL LireOPERANDE2H 
    MOV AX, result   
    MOV OP1, AX  
    JMP IGNORE9 
     
ADDHX:
    CALL LireOperandesH

IGNORE9: 
    
    MOV AX,OP1 
    ADD AX, OP2
    MOV RESULT,AX 
    JC ErreurOVERFLOWRESULT  
    CALL AfficheH 
    jmp Hexadecimale_suite
    
;;;;;;;;;;;;;;;;;;;;;;;;;; 

SUBHXsuite: 

    CALL LireOPERANDE2H 
    MOV AX, result   
    MOV OP1, AX  
    JMP IGNORE10     
    
SUBHX:  

    CALL LireOperandes    
    
IGNORE10: 
    
    MOV AX,OP1
    SUB AX, OP2
    MOV RESULT, AX     
    JC ErreurOVERFLOWRESULT 
    CALL AfficheH 
    jmp Hexadecimale_suite
    
;;;;;;;;;;;;;;;;;;;;;;;;;;

MULHXSuite:

    CALL LireOPERANDE2H   
    MOV AX, result   
    MOV OP1, AX 
    JMP IGNORE11  
    
MULHX:  

    CALL LireOperandesH  

IGNORE11:  
     
    MOV AX,OP1
    MOV bx,OP2
    MUL bx
    MOV RESULT,AX 
    JC ErreurOVERFLOWRESULT 
    CALL AfficheH         
    jmp Hexadecimale_suite
   
;;;;;;;;;;;;;;;;;;;;;;;;;;

DIVHXSuite:     

    CALL LireOPERANDE2H
    MOV AX, result   
    MOV OP1, AX   
    JMP IGNORE12 
    
DIVHX: 

    CALL LireOperandesH
     
IGNORE12:
    
    MOV dx, 0
    CMP AX, 0
    JZ ErreurZero 
    MOV AX,OP1
    MOV bx,OP2
    DIV bx
    MOV RESULT,AX 
    JC ErreurOVERFLOWRESULT 
    CALL AfficheH 
    jmp Hexadecimale_suite    

    ;;;TRAITEMENT D'ERREURS;;;  
     
ErreurZero:  

    MOV dx, offset Erreur0
    MOV ah, 9
    int 21h
    JMP BOUCLE1  
    
    ;Erreurs d'insertions
    
ErreurINPUT:
 
    MOV dx, offset ErreurIN
    MOV ah, 9
    int 21h
    JMP BOUCLE1      
    
ErreurINPUT_DEC:  

    MOV dx, offset ErreurIN
    MOV ah, 9
    int 21h
    JMP decimale  
    
ErreurINPUT_B: 

    MOV dx, offset ErreurIN
    MOV ah, 9
    int 21h
    JMP binaire 

ErreurINPUT_HX:
 
    MOV dx, offset ErreurIN
    MOV ah, 9
    int 21h
    JMP hexadecimale    
                                              
ErreurOP1LesserThanOP2:

    MOV dx, offset ErreurOP1OP2
    MOV ah, 9
    int 21h
    JMP decimale   

    ;Si le resultat depasse la taille de la variable ou il est stocke 
      
ErreurOVERFLOWRESULT: 

    MOV dx, offset ErreurOFR
    MOV ah, 9
    int 21h
    JMP BOUCLE1     
    
    ;Si l'operande depasse la taille de la variable ou il est stocke      
    
ErreurOVERFLOWOP: 
    
    MOV dx, offset ErreurOF
    MOV ah, 9
    int 21h
    JMP BOUCLE1
                         
    ;;;DECLARATION DE FONCTIONS;;; 
    
    ;Fonction pour intialiser les registres
    
    Init proc 
        
    MOV AX, 0;
    MOV bx, 0;
    MOV dx, 0; 
    ret
    
    Init endp  
    
    
    ;Fonction pour afficher le message d'accueil
    
    Welcome proc  
        
    MOV dx, offset MessageAccueil
    MOV ah, 9
    int 21h 
    ret         
    
    Welcome endp 
    
    
    ;Fonction qui affiche le menu des modes 
    
    ModeMenu proc   
       
    MOV dx, offset Menu1
    MOV ah, 9
    int 21h  
    ret
    
    ModeMenu endp
     
    ;Fonction qui fait la Lecture du choix du mode  
    
    ModeChoice proc
    
    MOV ah, 1
    int 21h
    MOV MODE, al        
    ret
    
    ModeChoice endp  
    
    ;Fonction qui saute vers le mode voulu
    
    goToMODE proc 
        
    CMP MODE,'1'                           
    JE decimale;  
    CMP MODE,'2'
    JE binaire;  
    CMP MODE,'3'
    JE hexadecimale;   
    CMP MODE, 'x'  
    JE END  
    JNE ErreurINPUT      
    ret 
    
    goToMode endp    
                          
    ;Fonction affichage message : entrez operande 1
    
    EnterOP1 proc
    
    push dx
    MOV dx, offset Message1
    MOV ah, 9
    int 21h   
    pop dx
    ret  
    
    EnterOP1 endp
      
    ;Fonction affichage message : entrez operande 2
    
    EnterOP2 proc
    
    push dx
    MOV dx, offset Message2
    MOV ah, 9
    int 21h
    pop dx
    ret  
    
    EnterOP2 endp
    
    ;Fonction qui affiche le menu des operations 
                            
    OPMenu proc 
        
    MOV dx, offset Menu2
    MOV ah, 9
    int 21h         
    ret   
  
    OPMenu endp   
     
    ;Fonction qui lis le choix d'operation
                  
    OPChoice proc
                    
    MOV ah, 1
    int 21h
    MOV OPERATION, al   
            
    ret
    
    OPChoice endp        
    
    ;Fonction affichage du caractere l'operation (+, -, *, /)  
    
    OperationAffichage proc 
    
    MOV ah, 2
    MOV dl, OPERATION    
    int 21h  
    ret 
    
    OperationAffichage endp 
    
    ;Afficher le symbole "="
    
    EgalAffichage proc
        
    MOV dx, offset Egal
    MOV ah, 9
    int 21h
    ret
    
    EgalAffichage endp
    
    ;Fonction affichage du menu d'operations avec la possibilite de continuer avec le resultat precedent
    
    OperationMenuSuite proc    
    
    MOV dx, offset Menu3
    MOV ah, 9
    int 21h  
    ret      
    
    OperationMenuSuite endp    

    ;;Fonction qui traite le choix de l'operation de l'utilisateur du mode DECIMALE;;
    
    DecimaleOP proc    
    
    CMP OPERATION,'+'
    JE ADDD;    
    CMP OPERATION,'-'
    JE SUBD;  
    CMP OPERATION,'*'
    JE MULD;
    CMP OPERATION,'/'
    JE DIVD;   
    CMP OPERATION,'x'  
    JE END  
    JNE ErreurINPUT_DEC; 
    ret        
    DecimaleOP endp
    
    
    ;;Fonction qui traite le choix de l'operation de l'utilisateur du mode DECIMALE en ajoutant l'option mettre a 0;;
    
    DecimaleOPsuite proc    
    
    CMP OPERATION,'+'
    JE ADDDsuite;    
    CMP OPERATION,'-'
    JE SUBDsuite;  
    CMP OPERATION,'*'
    JE MULDsuite;
    CMP OPERATION,'/'
    JE DIVDsuite;   
    CMP OPERATION,'x'  
    JE END    
    CMP OPERATION,'0'
    JE BOUCLE1_remis_a_0
    JNE ErreurINPUT_DEC; 
           
    DecimaleOPsuite endp
        
    ;;Fonction qui traite le choix de l'operation de l'utilisateur du mode BINAIRE;;
                      
    BinaireOP proc  
        
    CMP OPERATION,'+'
    JE ADDB;    
    CMP OPERATION,'-'
    JE SUBB;  
    CMP OPERATION,'*'
    JE MULB;
    CMP OPERATION,'/'
    JE DIVB;
    CMP OPERATION,'x'  
    JE END  
    JNE ErreurINPUT_B;               
    ret            
    BinaireOP endp    
            
    ;;Fonction qui traite le choix de l'operation de l'utilisateur du mode BINAIRE en ajoutant l'option mettre a 0;;
                      
    BinaireOPsuite proc  
        
    CMP OPERATION,'+'
    JE ADDBsuite;    
    CMP OPERATION,'-'
    JE SUBBsuite;  
    CMP OPERATION,'*'
    JE MULBsuite;
    CMP OPERATION,'/'
    JE DIVBsuite;
    CMP OPERATION,'x'  
    JE END      
    CMP OPERATION,'0'
    JE BOUCLE1_remis_a_0;
    JNE ErreurINPUT_B;               
    ret            
    BinaireOPsuite endp

    ;;Fonction qui traite le choix de l'operation de l'utilisateur du mode HEXADECIMALE;;
        
    HexadecimaleOP proc  
    
    CMP OPERATION,'+'
    JE ADDHX;    
    CMP OPERATION,'-'
    JE SUBHX;  
    CMP OPERATION,'*'
    JE MULHX;
    CMP OPERATION, '/'
    JE DIVHX;     
    CMP OPERATION, 'x'  
    JE END  
    JNE ErreurINPUT_HX;
    ret   
    HexadecimaleOP endp  
    
    ;;Fonction qui traite le choix de l'operation de l'utilisateur du mode HEXADECIMALE en ajoutant l'option mettre a 0;;
        
    HexadecimaleOPsuite proc  
    
    CMP OPERATION,'+'
    JE ADDHXsuite;    
    CMP OPERATION,'-'
    JE SUBHXsuite;  
    CMP OPERATION,'*'
    JE MULHXsuite;
    CMP OPERATION, '/'
    JE DIVHXsuite;     
    CMP OPERATION, 'x'  
    JE END   
    CMP OPERATION, '0'
    JE BOUCLE1_remis_a_0;
    JNE ErreurINPUT_HX;
    ret   
    HexadecimaleOPsuite endp  
    
   
    ;Fonction pour lire une entree en "Decimale"  
                  
LireDecimal PROC     
        
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV DX, OFFSET DString
    LEA SI, DString[1]
    MOV DString[0], 6

    MOV AH, 0AH
    INT 21h

    MOV AL, '$'
    MOV BYTE PTR [SI], AL 
    

    POP DX
    POP CX
    POP BX
    POP AX
    
    RET    
    
LireDecimal ENDP 

    ;Fonction pour lire une entree en "binaire"
    
    LireBinaire PROC 
        
    PUSH AX 
    PUSH DX  
    
    MOV AH, 0AH
    MOV DX, OFFSET BString
    MOV BString[0], 17
    INT 21h
    
    POP DX
    pop AX
    
    RET     
    
    LireBinaire ENDP 
                     
    ;Fonction pour lire une entree en "Hexadecimale"      
    
    LireHexa PROC 
        
    PUSH AX
    PUSH DX
    MOV AH, 0AH
    MOV DX, OFFSET HString
    MOV HString[0], 5
    INT 21h
    POP DX
    pop AX 
    
    RET 
    
    LireHexa ENDP  
    
    ;Fonction pour Verifier qu'une entree est en decimale  
    
    EstDecimal PROC
        
    PUSH AX
    PUSH CX
    PUSH SI
    
    MOV SI, OFFSET DString
    MOV CL, 13
    MOV CH, 0
    MOV BX, 10
    ADD SI,2
    
RechercheChiffre:    

    JE FinEstDecimal
    MOV AL, [SI]
    CMP AL,CL
    JE FinEstDecimal
    CMP AL, '0'
    JL EstDecimalInvalide
    CMP AL, '9'
    JG EstDecimalInvalide
    INC SI
    JMP RechercheChiffre
    
EstDecimalInvalide:   

    JMP ErreurINPUT_DEC
    
FinEstDecimal: 

    POP SI
    POP CX
    POP AX
    RET
    
EstDecimal ENDP
    
    ;Fonction pour Verifier qu'une entree est en binaire
         
    EstBinaire PROC
    
    PUSH AX 
    PUSH CX
    PUSH SI 
    MOV BL, 1
    MOV SI, 1; 
    MOV CX, 0
    MOV CL, BString[1]
    ADD CX, 1 
    
Reboucler:  

    INC SI 
    CMP SI, CX
    JG Fin 
    
    CMP BString[SI], '0' 
    JE Reboucler 
    CMP BString[SI], '1' 
    JE Reboucler
    
    ; Saut vers l'etiquette d'erreur si l'entree est invalide 
    
    JMP ErreurINPUT_B
              
    Fin:
    
    POP SI
    POP CX
    POP AX
    RET               

EstBinaire ENDP
    
   ;Fonction pour Verifier qu'une entree est en Hexadecimale 
    
    EstHexa PROC 
                
    PUSH AX
    PUSH CX
    PUSH SI
    MOV DI, OFFSET HString +2
    MOV CX, 0
    MOV CL, 0Dh  
    
RebouclerHex:  

    MOV DL, [DI]
    CMP CL, DL
    JE FinHex 
    CMP DL, '0'
    JL skip    
    CMP DL, '9'
    JG skip
    JMP skiptheskip

skip: 
   
    CMP DL, 'A'
    JL SortirHex
    CMP DL, 'F'
    JG SortirHex
    
skiptheskip:

    INC DI     
    
    JMP RebouclerHex
    
    ; Si le caractere n'est pas compris entre '0' et 'F', on sort
    
SortirHex: 

    JMP ErreurINPUT_HX
    
FinHex: 

    POP SI
    POP CX
    POP AX
    
    
    RET
    
EstHexa ENDP

   ;Fonction pour afficher un resultat en decimale 
   
 PrintDecimal PROC
    
    MOV cx, 0
    MOV bx, 10
              
empiler:
      
    xor dx, dx
    DIV bx     
    ADD dx, 48  
    push dx     
    inc cx       
    test AX, AX
    jnz empiler
              
depiler:   

    pop dx       
    MOV ah, 02h
    int 21h
    loop depiler 
    
    ret     
    
PrintDecimal ENDP
        
    ;Fonction pour Afficher un resultat en binaire
                                     
    PrintBinary PROC
    MOV bx, AX
    MOV cx, 16    
    
print:  

    MOV ah, 02h
    MOV dl, '0'
    test bx, 1000000000000000b
    JZ zero
    MOV dl, '1' 
    
zero: 

    int 21h
    shl bx, 1
    loop print 
    
    RET      
    
PrintBinary ENDP
 
   ;Fonction pour afficher un resultat en hexadecimale
    
    PrintHexa Proc   
        
    MOV bx,AX
    and AX,1111000000000000b ;garder que les premiers
    shr AX,12
    
    CMP al,9
    jle chiffre1
    ADD al,37h  ;lettre A=10+37=41h=65d =code ascii
    MOV dl,al
    MOV ah,02h
    int 21h
    jmp second
    
chiffre1:    

    ADD al,30h  ;pour convertir en caractere
    MOV dl,al
    MOV ah,02h
    int 21h

second:   

    MOV AX,bx
    and AX,0000111100000000b
    shr AX,8
    CMP al,9
    jle chiffre2
    ADD al,37h
    MOV dl,al
    MOV ah,02h
    int 21h
    jmp third 
    
chiffre2:

    ADD al,30h 
    MOV dl,al
    MOV ah,02h
    int 21h 
    
third:  

    MOV AX,bx
    and AX,0000000011110000b
    shr AX,4
    CMP al,9
    jle chiffre3
    ADD al,37h
    MOV dl,al
    MOV ah,02h
    int 21h
    jmp forth 
    
chiffre3: 

    ADD al,30h 
    MOV dl,al
    MOV ah,02h
    int 21h
    
forth:   

    MOV AX,bx
    and AX,0000000000001111b
    CMP al,9
    jle chiffre4
    ADD al,37h 
    MOV dl,al
    MOV ah,02h
    int 21h
    jmp fin6   
    
chiffre4:  

    ADD al,30h 
    MOV dl,al
    MOV ah,02h
    int 21h
    
fin6:
       
    ret  
    
    PrintHexa endp   
    
    ;Fonction pour convertir une chaine de caracteres en decimale
    
   StringToDec PROC
     
    CALL EstDecimal

    MOV AX, 0
    MOV CX, 0
    MOV DX, 0
    MOV DI, OFFSET DString+2 
    MOV cl, 13
    
Reboucler3:  

    MOV dl, [DI]
    CMP dl, 13
    je Fin3 
    MOV bx,10
    MUL bx   
    jc erreuroverflowop  
    MOV dl, [DI]
    sub dl, 30h 
    MOV dh, 0
    INC DI       
    ADD AX,dx  
    jc erreuroverflowop        
  
    jnz Reboucler3 

Fin3:
 
    RET 
    
StringToDec ENDP     
   
    ;Fonction pour convertir une chaine de caracteres en binaire
    
    StringToBinary PROC
    
    CALL EstBinaire 
 
    MOV AX, 0
    MOV BX, DX
    MOV CX, 0 
    MOV CL, [BX+1]
    ADD CX, 1                     
    MOV SI, 1 
      
Reboucler4:
    
    INC SI
    CMP SI, CX
    JG Fin4
    SHL AX, 1 
    CMP [BX+SI], '1'
    
    JNE Reboucler4 
    ADD AX, 1 
    JMP Reboucler4
    
Fin4:
    
    RET    
   
    StringToBinary ENDP  
    
    ;Fonction pour convertir une chaine de caracteres en hexadecimale
     
    StringToHex PROC 
        
    CALL EstHexa
    
    MOV AX, 0
    MOV DI,OFFSET HString + 2
    MOV CX, 0
    MOV CL,0Dh
    
Reboucler5:
 
    MOV DL,[DI]
    CMP DL,CL
    JE Fin5
    MOV BX,16
    MUL BX
    MOV DL,[DI]                   
    SUB DL, '0'
    CMP DL, 9
    JG NoADD
    MOV DH,0
    ADD AX,DX
    INC DI
    JMP Reboucler5
    
NoADD: 

    MOV DL,[DI]
    SUB DL,55
    MOV DH,0
    ADD AX, DX
    INC DI
    JMP Reboucler5

Fin5:
        
    RET

StringToHex ENDP

    ;Fonction affichage fin
    
    EndMessage proc
        
    MOV dx, offset MessageFIN
    MOV ah, 9
    int 21h      
    
    ret
       
    EndMessage endp   

    ;Fonction Message "supression du resultat precedent"
     
    AlerteMessage proc
    
    MOV dx, offset MessageAlerte 
    MOV ah, 9
    int 21h
    
    ret
    
    AlerteMessage endp
    
    ;Fonction pour repeter la Boucle 1 
    
    Boucle1repeat proc
        
    CALL ModeMenu;   
    CALL ModeChoice;
    CALL goToMODE;  
    
    ret
    
    Boucle1repeat endp    
    

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    
    ;;;;;;DECIMAL;;;;;;
      
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;FONCTION POUR AFFICHER LE RESULTAT EN DECIMAL 
    
    Affiche proc
    
    MOV dx, offset Espace
    MOV ah, 9
    int 21h 
    
    ;Afficher le premier operande 
    
    MOV AX, OP1  
    CALL printdecimal 
    
    ;Afficher le symbole de l'operation
    
    CALL OperationAffichage    
    
    ;Afficher le deuxieme operande  
    
    MOV AX, OP2
    CALL printdecimal 
    
    ;Afficher signe d'egalite
     
    CALL EgalAffichage
    MOV AX, result
    CALL printdecimal 
    
    ret       

    Affiche endp  
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;FONCTION POUR LIRE LES OPERANDES DECIMAUX
     
    LireOperandes proc
        
    ;Fonction pour lire le premier operande 
    
    CALL EnterOP1;       
    CALL LireDecimal;  
    
    ;Fonction pour convertir la chaine de caracteres en decimale 
    
    MOV dx,offset DString    
    CALL StringToDec; 

     
    ;Stocker le premier operande dans OP1 
     
    MOV OP1,AX   
    
    ;Fonction pour lire le deuxieme operande
    
    CALL EnterOP2;       
    CALL LireDecimal;
       
    ;Fonction pour convertir la chaine de caracteres en decimale
     
    MOV dx,offset DString
    CALL StringToDec;  
    
    ;Stocker le deuxieme operande dans OP2 
    
    MOV OP2,AX 
    ret  
    
    LireOperandes endp 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;FONCTION POUR LIRE LE SECOND OPERANDE DECIMAL SEULEMENT 
    
    LireOPERANDE2 proc
         
    ;Fonction pour lire le deuxieme operande
    
    CALL EnterOP2;       
    
    CALL Liredecimal;   
    
    ;Fonction pour convertir la chaine de caracteres en decimale
         
    MOV dx,offset DString
    
    CALL StringToDEC;  
    
    ;Stocker le deuxieme operande dans OP2
    
    MOV OP2,AX       
    
    ret 
    
    LireOPERANDE2 endp
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;;BINAIRE;;;;;;
     
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    ;FONCTION POUR AFFICHER LE RESULTAT EN DECIMAL 
    
    AfficheB proc
    
    MOV dx, offset Espace
    MOV ah, 9
    int 21h 
    
    ;Afficher le premier operande 
    
    MOV AX, OP1
    CALL printbinary 
    
    ;Afficher le symbole de l'operation
    
    CALL OperationAffichage    
    
    ;Afficher le deuxieme operande  
    
    MOV AX, OP2
    CALL printbinary 
    
    ;Afficher signe d'egalite
     
    CALL EgalAffichage
    MOV AX, result
    CALL printbinary 
    
    ret       

    AfficheB endp   
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;FONCTION POUR LIRE LES OPERANDES BINAIRES
    
    LireOperandesB proc
        
    CALL EnterOP1;       
    CALL LireBinaire;  
    
    ;Fonction pour convertir la chaine de caracteres en decimale 
    
    MOV dx,offset BString    
    CALL StringToBinary;  
     
    ;Stocker le premier operande dans OP1 
     
    MOV OP1,AX    
    
    ;Fonction pour lire le deuxieme operande
    
    CALL EnterOP2;       
    CALL LireBinaire;   
    
    ;Fonction pour convertir la chaine de caracteres en decimale
     
    MOV dx,offset BString
    CALL StringToBinary;  
    
    ;Stocker le premier operande dans OP2 
    
    MOV OP2,AX    
    ret          
    
    LireOperandesB endp 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;FONCTION POUR LIRE LE SECOND OPERANDE BINAIRE SEULEMENT 
    
    LireOPERANDE2B proc
         
    ;Fonction pour lire le deuxieme operande
    
    CALL EnterOP2;       
    
    CALL LireBinaire;   
    
    ;Fonction pour convertir la chaine de caracteres en decimale
         
    MOV dx,offset BString
    
    CALL StringToBinary; 
    
    ;Stocker le premier operande dans OP2
    
    MOV OP2,AX         
    
    ret 
    
    LireOPERANDE2B endp    
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;;HEXADECIMALE;;;;;;
    
    AfficheH proc
    
    MOV dx, offset Espace
    MOV ah, 9
    int 21h 
    
    ;Afficher le premier operande 
    
    MOV AX, OP1
    CALL printHexa 
    
    ;Afficher le symbole de l'operation
    
    CALL OperationAffichage    
    
    ;Afficher le deuxieme operande  
    
    MOV AX, OP2
    CALL printHexa 
    
    ;Afficher signe d'egalite
     
    CALL EgalAffichage
    MOV AX, result
    CALL printHexa 
    
    ret       
                  
    AfficheH endp
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;FONCTION POUR LIRE LES OPERANDES BINAIRES
     
    LireOperandesH proc
        
    ;Fonction pour lire le premier operande 
    
    CALL EnterOP1;       
    CALL LireHexa;
    
    ;Fonction pour convertir la chaine de caracteres en decimale 
    
    MOV dx,offset HString    
    CALL StringToHex;
       
    ;Stocker le premier operande dans OP1 
     
    MOV OP1,AX
      
    ;Fonction pour lire le deuxieme operande
    
    CALL EnterOP2;       
    CALL LireHexa;
       
    ;Fonction pour convertir la chaine de caracteres en decimale
     
    MOV dx,offset HString
    CALL StringToHex;  
    
    ;Stocker le premier operande dans OP2  
    
    MOV OP2,AX    
    ret  
    LireOperandesH endp 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;FONCTION POUR LIRE LE SECOND OPERANDE BINAIRE SEULEMENT 
    
    LireOPERANDE2H proc
         
    ;Fonction pour lire le deuxieme operande
    
    CALL EnterOP2;       
    
    CALL LireHexa;   
    
    ;Fonction pour convertir la chaine de caracteres en decimale
         
    MOV dx,offset HString
    
    CALL StringToHex; 
    
    ;Stocker le premier operande dans OP2
    
    MOV OP2,AX         
    
    ret 
    
    LireOPERANDE2H endp
    
END: 
    CALL EndMessage;     
    
    MOV AX, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.