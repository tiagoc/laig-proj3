% Autor: ei09093 & ei09103
% Data: 30-09-2011

:-use_module(library(sockets)).

:-dynamic(pieceForPlayer/2).
:-retractall(pieceForPlayer(_,_)).
:-assert(pieceForPlayer([bking, bqueen, brook1, brook2, bknight1 , bknight2, bbishop1, bbishop2], black)).
:-assert(pieceForPlayer([wking, wqueen, wrook1, wrook2, wknight1 , wknight2, wbishop1, wbishop2], white)).
:-dynamic(firstBishop/2).
:-retractall(firstBishop(_,_)).


piece(wking).
piece(wqueen).
piece(wrook1).
piece(wrook2).
piece(wknight1).
piece(wknight2).
piece(wbishop1).
piece(wbishop2).

piece(bking).
piece(bqueen).
piece(brook1).
piece(brook2).
piece(bknight1).
piece(bknight2).
piece(bbishop1).
piece(bbishop2).

acronym(wking, wki).
acronym(wqueen, wqu).
acronym(wrook1, wr1).
acronym(wrook2, wr2).
acronym(wknight1, wk1).
acronym(wknight2, wk2).
acronym(wbishop1, wb1).
acronym(wbishop2, wb2).

acronym(bking, bki).
acronym(bqueen, bqu).
acronym(brook1, br1).
acronym(brook2, br2).
acronym(bknight1, bk1).
acronym(bknight2, bk2).
acronym(bbishop1, bb1).
acronym(bbishop2, bb2).

%***************************************************************************
%*                                                                         *
%*                      Estado inicial do Tabuleiro                        *
%*                                                                         *
%***************************************************************************
%nota que a casa ' ' significa que a casa é branca e com 'X' significa que é preta
initBoard([['   ',' X ','   ',' X ','   ',' X ','   ',' X '],
           [' X ','   ',' X ','   ',' X ','   ',' X ','   '],
           ['   ',' X ','   ',' X ','   ',' X ','   ',' X '],
           [' X ','   ',' X ','   ',' X ','   ',' X ','   '],
           ['   ',' X ','   ',' X ','   ',' X ','   ',' X '],
           [' X ','   ',' X ','   ',' X ','   ',' X ','   '],
           ['   ',' X ','   ',' X ','   ',' X ','   ',' X '],
           [' X ','   ',' X ','   ',' X ','   ',' X ','   ']]).

           
%***************************************************************************
%*                                                                         *
%*                      Estado inicial do Tabuleiro                        *
%*                                                                         *
%***************************************************************************

viewTab(T) :- nl, write('     A     B     C     D     E     F     G     H'), nl,
                  write('  +-----+-----+-----+-----+-----+-----+-----+-----+'), nl,
                  printBoard(0, T).
viewTab(_).




printElement(E) :- write(E).

%imprime a cabeca da lista e a cauda operando recursivamente
printRowBoard([]).
printRowBoard([H|T]) :-  printElement(H),  write(' | '),  printRowBoard(T).

printBoard(_,[]).
printBoard(N ,[H|T]) :-  N1 is N + 1,  write(N1),  write(' | '),  printRowBoard(H),  nl,
  write('  +-----+-----+-----+-----+-----+-----+-----+-----+'), nl,  printBoard(N1, T).


printPieces([]).
printPieces([H|T]):- printRowBoard([H|T]).



%***************************************************************************
%*                                                                         *
%*                      Manipulação do Tabuleiro                           *
%*                                                                         *
%***************************************************************************

%*******************Inserir Peca no Tabuleiro*************************
% Substitui Linha
setLine(Board,PosY,PosX,Piece,EndBoard):- setLine_aux(Board,PosX,PosY,Piece,EndBoard).

setLine_aux(Board,-1,_PosY,_Piece,EndBoard):-  EndBoard=Board.

setLine_aux([H|T],PosX,PosY,Piece,[H|T2]):-  PosX>1,  Pos is PosX-1,  setLine_aux(T,Pos,PosY,Piece,T2).

setLine_aux([H|T],PosX,PosY,Piece,[H2|T2]):-  PosX=1,  setColumn(H,PosY,Piece,H2),  setLine_aux(T,-1,PosY,Piece,T2).

% Substitui Coluna
setColumn(Board,Pos,Piece,EndBoard):-  setColumn_aux(Board,1,Pos,Piece,EndBoard).

setColumn_aux([],_,_,_,[]).

setColumn_aux([_|T],Pos,Pos,Piece,[H2|T2]):-  H2=Piece,  Pos1 is Pos+1,  setColumn_aux(T,Pos1,Pos,Piece,T2).

setColumn_aux([H|T],Pos1,Pos,Piece,[H|T2]):-  Pos2 is Pos1+1,  setColumn_aux(T,Pos2,Pos,Piece,T2).


%********************** Posicao do tabuleiro esta vazia **********************
isEmpty(Board, PosX, PosY) :- returnPiece(Board, PosX, PosY, Piece), (Piece == '   '; Piece == ' X ').

%********************** Retorna Peca do Tabuleiro **********************

returnPiece([H|_],1,PosY,Piece):- returnPieceLine(H,PosY,Piece).
returnPiece([_|T],PosX,PosY,Piece):- PosX>1, PosX2 is PosX-1, returnPiece(T,PosX2,PosY,Piece).

returnPieceLine([H|_],1,H).
returnPieceLine([_|T],PosX,Piece):- PosX>1, PosX2 is PosX-1, returnPieceLine(T,PosX2,Piece).

        
%************************** Remove Peca da Lista ************************
removePiece([],_,[]) :- !.
removePiece([Piece|T],Piece,T2) :- removePiece(T,Piece,T2).
removePiece([H|T],Piece,[H|T2]) :- \+(Piece==H), removePiece(T,Piece,T2).

%***************   Verifica Possibilidade de Inserir Peca    ***************
                                         
                                
isPossible(Board, X, Y, Piece, LX, LY, N, Bool):-
       (N == 1 ->
          (Piece == wking ->
             (isEmpty(Board, X, Y) -> (isIn(X-Y) -> Bool = 1; Bool = 0))));
       (N == 16 ->
          (Piece == bking ->
              (isEmpty(Board, X, Y) -> (isIn(X-Y) -> getKingRange(X,Y,Ret),
           (member(X-Y, Ret) -> Bool = 1; Bool = 0)))));
       (N > 1, N < 15  -> (not(Piece == bking) ->(isEmpty(Board, X, Y) -> (isIn(X-Y) ->
                (getPieceRangeAux(X,Y,Piece,List),(member(LX-LY, List) -> Bool = 1; Bool = 0)))))).

getPieceRangeAux(X,Y,Piece, Ret):-
    (isKnight(Piece) -> getKnightRange(X,Y,Ret));
    (isRook(Piece) -> getRookRange(X,Y,Ret));
    (isBishop(Piece) -> getBishopRange(X,Y,Ret));
    (isQueen(Piece) -> getQueenRange(X,Y,Ret)).
    

%************************ Analisa os Bishop ***********************


%***************verifica de que tipo sao as pecas******************
isKnight(Piece):-
   Piece == bknight1; Piece == bknight2;
   Piece == wknight1; Piece == wknight2.
isRook(Piece):-
   Piece == brook1; Piece == brook2;
   Piece == wrook1; Piece == wrook2.
isBishop(Piece):-
   Piece == bbishop1; Piece == bbishop2;
   Piece == wbishop1; Piece == wbishop2.
isQueen(Piece):-
   Piece == bqueen; Piece == wqueen.
                                
%isIn(X-Y).
%length([],S).

/*state(Nx-Ny, Lx-Ly, NumMove) :-
getKnightRange(X,Y,Ret),
getRookRange(X,Y,Ret),
getBishopRange(X,Y,Ret),
getQueenRange(X,Y,Ret).*/


%***************   Efectuar a jogada    ***************
playPiece(Board, Piece, X, Y, EndBoard) :- acronym(Piece, Ac),setLine(Board,Y,X,Ac,EndBoard).

%************************** Alcance da Peca ************************
% - se peca = rainha , alcance na diagonal, horizontal e vertical
% - se peca = rei, alcance 1 casa na diagonal, horizontal e vertical
% - se peca = bispo, alcance na diagonal
% - se peca = torre, alcance vertical, horizontal
% - se cavalo = L

isIn(X-Y):- X < 9, X > 0, Y < 9, Y > 0.

%********************** Knight Range ************************
getKnightRange(X,Y,Ret):-
     findall(X1-Y1,getKnightRangeAux(X,Y,X1,Y1),Ret).
     
getKnightRangeAux(X,Y,X1,Y1):-
    (X1 is X-1, Y1 is Y-2, isIn(X1-Y1));
    (X1 is X+1, Y1 is Y-2, isIn(X1-Y1));
    (X1 is X-1, Y1 is Y+2, isIn(X1-Y1));
    (X1 is X+1, Y1 is Y+2, isIn(X1-Y1));
    (X1 is X-2, Y1 is Y-1, isIn(X1-Y1));
    (X1 is X+2, Y1 is Y-1, isIn(X1-Y1));
    (X1 is X-2, Y1 is Y+1, isIn(X1-Y1));
    (X1 is X+2, Y1 is Y+1, isIn(X1-Y1)).

%********************** King Range ************************
getKingRange(X,Y,Ret):-
     findall(X1-Y1,getKingRangeAux(X,Y,X1,Y1),Ret).

getKingRangeAux(X,Y,X1,Y1):-
    (X1 is X, Y1 is Y-1, isIn(X1-Y1));
    (X1 is X, Y1 is Y+1, isIn(X1-Y1));
    (X1 is X-1, Y1 is Y, isIn(X1-Y1));
    (X1 is X+1, Y1 is Y, isIn(X1-Y1));
    (X1 is X-1, Y1 is Y-1, isIn(X1-Y1));
    (X1 is X+1, Y1 is Y-1, isIn(X1-Y1));
    (X1 is X-1, Y1 is Y+1, isIn(X1-Y1));
    (X1 is X+1, Y1 is Y+1, isIn(X1-Y1)).
    
%********************** Rook Range ************************
getRookRange(X,Y,Ret):-
   getRangeUp(X,Y,_,L1),getRangeDown(X,Y,_,L2),
   getRangeLeft(X,Y,_,L3),getRangeRight(X,Y,_,L4),
   append(L1,L2,L5),append(L5,L3,L6),append(L6,L4,Ret),!.

getRangeUp(X,Y,Temp,List):-
   (Y1 is Y+1, isIn(X-Y1) -> append(Temp,[X-Y1],Temp1),
   getRangeUp(X,Y1,Temp1,List);append(Temp,[],List)).

getRangeDown(X,Y,Temp,List):-
   (Y1 is Y-1, isIn(X-Y1) -> append(Temp,[X-Y1],Temp1),
   getRangeDown(X,Y1,Temp1,List);append(Temp,[],List)).
   
getRangeLeft(X,Y,Temp,List):-
   (X1 is X-1, isIn(X1-Y) -> append(Temp,[X1-Y],Temp1),
   getRangeLeft(X1,Y,Temp1,List);append(Temp,[],List)).

getRangeRight(X,Y,Temp,List):-
   (X1 is X+1, isIn(X1-Y) -> append(Temp,[X1-Y],Temp1),
   getRangeRight(X1,Y,Temp1,List);append(Temp,[],List)).

%********************** Bishop Range ************************

getBishopRange(X,Y,Ret):-
   getRangeUpRight(X,Y,_,L1),getRangeDownRight(X,Y,_,L2),
   getRangeUpLeft(X,Y,_,L3),getRangeDownLeft(X,Y,_,L4),
   append(L1,L2,L5),append(L5,L3,L6),append(L6,L4,Ret),!.

getRangeUpRight(X,Y,Temp,List):-
   (X1 is X+1, Y1 is Y+1, isIn(X1-Y1) -> append(Temp,[X1-Y1],Temp1),
   getRangeUpRight(X1,Y1,Temp1,List);append(Temp,[],List)).

getRangeDownRight(X,Y,Temp,List):-
   (X1 is X+1, Y1 is Y-1, isIn(X1-Y1) -> append(Temp,[X1-Y1],Temp1),
   getRangeDownRight(X1,Y1,Temp1,List);append(Temp,[],List)).

getRangeUpLeft(X,Y,Temp,List):-
   (X1 is X-1, Y1 is Y+1, isIn(X1-Y1) -> append(Temp,[X1-Y1],Temp1),
   getRangeUpLeft(X1,Y1,Temp1,List);append(Temp,[],List)).

getRangeDownLeft(X,Y,Temp,List):-
   (X1 is X-1, Y1 is Y-1, isIn(X1-Y1) -> append(Temp,[X1-Y1],Temp1),
   getRangeDownLeft(X1,Y1,Temp1,List);append(Temp,[],List)).
   
%********************** Queen Range ************************

getQueenRange(X,Y,Ret):-
   getRangeUp(X,Y,_,L1),getRangeDown(X,Y,_,L2),
   getRangeLeft(X,Y,_,L3),getRangeRight(X,Y,_,L4),
   getRangeUpRight(X,Y,_,L5),getRangeDownRight(X,Y,_,L6),
   getRangeUpLeft(X,Y,_,L7),getRangeDownLeft(X,Y,_,L8),
   append(L1,L2,L9),append(L9,L3,L10),append(L10,L4,L11),
   append(L11,L5,L12),append(L12,L6,L13),append(L13,L7,L14),
   append(L14,L8,Ret),!.

%************************** Pontuacao da Peca ************************

%************************** King Score ***********************
getKingScore(Board,Piece,X,Y,N,Total):-
    (X1 is X, Y1 is Y+1, isIn(X-Y1) ->
        (returnPiece(Board,X1,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1;N2 = N); N2 = N),
    (X2 is X, Y2 is Y-1, isIn(X2-Y2) ->
                (returnPiece(Board,X2,Y2,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                    N3 = N2+1;N3 =N2); N3 = N2),
    (X3 is X-1, Y3 is Y, isIn(X3-Y3) ->
              (returnPiece(Board,X3,Y3,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N4 = N3+1;N4 = N3); N4 = N3),
    (X4 is X+1, Y4 is Y, isIn(X4-Y4) ->
              (returnPiece(Board,X4,Y4,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N5 = N4+1;N5 = N4); N5 = N4),
    (X5 is X-1, Y5 is Y-1, isIn(X5-Y5) ->
              (returnPiece(Board,X5,Y5,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N6 = N6+1;N6 = N5); N6 = N5),
    (X6 is X+1, Y6 is Y-1, isIn(X6-Y6) ->
              (returnPiece(Board,X6,Y6,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N7 = N7+1;N7 = N6); N7 = N6),
    (X7 is X-1, Y7 is Y+1, isIn(X7-Y7) ->
              (returnPiece(Board,X7,Y7,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N8 = N8+1;N8 = N7); N8 = N7),
    (X8 is X+1, Y8 is Y+1, isIn(X1-Y1) ->
              (returnPiece(Board,X8,Y8,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N9 = N9+1;N9 = N8); N9 = N8), Total = N9.

%************************** Knight Score ***********************
getKnightScore(Board,Piece,X,Y,N,Total):-
    (X1 is X-1, Y1 is Y-2, isIn(X-Y1) ->
        (returnPiece(Board,X1,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1;N2 = N); N2 = N),
    (X2 is X+1, Y2 is Y-2, isIn(X2-Y2) ->
                (returnPiece(Board,X2,Y2,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                    N3 = N2+1;N3 =N2); N3 = N2),
    (X3 is X-1, Y3 is Y+2, isIn(X3-Y3) ->
              (returnPiece(Board,X3,Y3,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N4 = N3+1;N4 = N3); N4 = N3),
    (X4 is X+1, Y4 is Y+2, isIn(X4-Y4) ->
              (returnPiece(Board,X4,Y4,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N5 = N4+1;N5 = N4); N5 = N4),
    (X5 is X-2, Y5 is Y-1, isIn(X5-Y5) ->
              (returnPiece(Board,X5,Y5,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N6 = N6+1;N6 = N5); N6 = N5),
    (X6 is X+2, Y6 is Y-1, isIn(X6-Y6) ->
              (returnPiece(Board,X6,Y6,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N7 = N7+1;N7 = N6); N7 = N6),
    (X7 is X-2, Y7 is Y+1, isIn(X7-Y7) ->
              (returnPiece(Board,X7,Y7,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N8 = N8+1;N8 = N7); N8 = N7),
    (X8 is X+2, Y8 is Y+1, isIn(X8-Y8) ->
              (returnPiece(Board,X8,Y8,Piece2), (Piece2 == ' X '; Piece == '   ') ->
                  N9 = N9+1;N9 = N8); N9 = N8), Total = N9.
                  
%*********************** Rook Score **************************
getRookScore(Board,Piece,X,Y,_,Total):-
    getScoreUp(Board,Piece,X,Y,0,T1),getScoreDown(Board,Piece,X,Y,0,T2),
    getScoreLeft(Board,Piece,X,Y,0,T3),getScoreRight(Board,Piece,X,Y,0,T4),
    Total = T1 + T2 + T3 + T4.

getScoreUp(Board,Piece,X,Y,N,Total):-
   (Y1 is Y+1, isIn(X-Y1) ->
        (returnPiece(Board,X,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreUp(Board, Piece, X,Y1,N2,Total); Total = N2)).
            
getScoreDown(Board,Piece,X,Y,N,Total):-
   (Y1 is Y-1, isIn(X-Y1) ->
        (returnPiece(Board,X,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreDown(Board, Piece, X,Y1,N2,Total); Total = N2)).

getScoreLeft(Board,Piece,X,Y,N,Total):-
   (X1 is X-1, isIn(X1-Y) ->
        (returnPiece(Board,X,_,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreLeft(Board, Piece, X1,Y,N2,Total); Total = N2)).
            
getScoreRight(Board,Piece,X,Y,N,Total):-
   (X1 is X+1, isIn(X1-Y) ->
        (returnPiece(Board,X,_,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreRight(Board, Piece, X1,Y,N2,Total); Total = N2)).

%********************** Bishop Score **************************

getBishopScore(Board,Piece,X,Y,_,Total):-
    getScoreUpRight(Board,Piece,X,Y,0,T1),getScoreDownRight(Board,Piece,X,Y,0,T2),
    getScoreUpLeft(Board,Piece,X,Y,0,T3),getScoreDownLeft(Board,Piece,X,Y,0,T4),
    Total = T1 + T2 + T3 + T4.

getScoreUpRight(Board,Piece,X,Y,N,Total):-
   (X1 is X+1, Y1 is Y+1, isIn(X1-Y1) ->
        (returnPiece(Board,X1,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreUpRight(Board, Piece, X1,Y1,N2,Total); Total = N2)).

getScoreDownRight(Board,Piece,X,Y,N,Total):-
   (X1 is X+1, Y1 is Y-1, isIn(X1-Y1) ->
        (returnPiece(Board,X,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreDownRight(Board, Piece, X1,Y1,N2,Total); Total = N2)).

getScoreUpLeft(Board,Piece,X,Y,N,Total):-
   (X1 is X-1, Y1 is Y+1, isIn(X1-Y1) ->
        (returnPiece(Board,X1,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreUpLeft(Board, Piece, X1,Y1,N2,Total); Total = N2)).

getScoreDownLeft(Board,Piece,X,Y,N,Total):-
   (X1 is X-1, Y1 is Y-1, isIn(X1-Y1) ->
        (returnPiece(Board,X,Y1,Piece2), (Piece2 == ' X '; Piece2 == '   ') ->
            N2 = N+1, getScoreDownLeft(Board, Piece, X1,Y,N2,Total); Total = N2)).
            
%********************** Queen Score ****************************

getQueenScore(Board,Piece,X,Y,_,Total):-
    getScoreUp(Board,Piece,X,Y,0,T1),getScoreDown(Board,Piece,X,Y,0,T2),
    getScoreLeft(Board,Piece,X,Y,0,T3),getScoreRight(Board,Piece,X,Y,0,T4),
    getScoreUpRight(Board,Piece,X,Y,0,T5),getScoreDownRight(Board,Piece,X,Y,0,T6),
    getScoreUpLeft(Board,Piece,X,Y,0,T7),getScoreDownLeft(Board,Piece,X,Y,0,T8),
    Total = T1 + T2 + T3 + T4 + T5 + T6 + T7 + T8.

%***************************************************************************
%*                                                                         *
%*                                 TESTES                                  *
%*                                                                         *
%***************************************************************************
teste1(Tab):- initBoard(X),!, setLine(X,3,7,br1,Tab), !.
 
teste2(Tab) :-  initBoard(X),  returnPiece(X, 3, 3, Tab).

teste3(Tab) :-  getBishopRange(3,3, Tab).

teste4(O) :- removePiece(_, bking, O).

teste5(X,Y) :- initBoard(Lista), returnPiece(Lista,X,Y,' X ').

teste6 :- initBoard(X), isEmpty(X, 3, 3).

%***************************************************************************
%*                                                                         *
%*                           INICIO DO PROGRAMA                            *
%*                                                                         *
%***************************************************************************

%**************************** Menu Interno ***********************
game:-nl, titulo,
     nl, nl,
     print('1. New Game'),nl,
     read(Option),
     (Option > 0, Option <4 -> (Option == 1 -> init; halt)).


init:- initBoard(Board), viewTab(Board),  move(white,Board, 0, 0, 1).

move(Player, Tab, LX, LY, N):-
  pieceForPlayer(L, Player),
  printPieces(L), nl, 
  print('Choose piece: '), read(Piece),
  print('X:'), read(X),
  print('Y:'), read(Y),
  (isPossible(Tab, X, Y, Piece, LX, LY, N, Bool), Bool = 1 ->
  continueMove(Player, Tab, X, Y, Piece, L, N);
    write('This move is impossible!'),nl, move(Player, Tab, LX, LY, N)).
  
continueMove(Player, Tab, X, Y, Piece, L, N):-
  N1 is N +  1,
  playPiece(Tab, Piece, X, Y, EndBoard), viewTab(EndBoard),
  retract(pieceForPlayer(_, Player)),
  removePiece(L, Piece, L2),
  assert(pieceForPlayer(L2, Player)),
  (Player == white -> Player2 = black; Player2 = white),
  (L2 == [] , Player == black -> write('END OF THE GAME'); move(Player2, EndBoard, X, Y, N1)).
  

titulo:-
write('  %%%%%%%%  %%    %%  %%%%%%%%  %%    %%  %%%%%%%%  %%%%%%%    %%%%%%  %%%%%%%%'),nl,
write('  %%%%%%%%  %%    %%  %%%%%%%%  %%    %%  %%%%%%%%  %%%%%%%%  %%%%%%%  %%%%%%%%'),nl,
write('  %%        %%    %%  %%        %%    %%  %%        %%     %% %%          %%   '),nl,
write('  %%        %%    %%  %%        %%    %%  %%        %%     %% %%          %%   '),nl,
write('  %%        %%    %%  %%        %%    %%  %%        %%    %%  %%          %%   '),nl,
write('  %%        %%%%%%%%  %%%%%     %%    %%  %%%%%%    %%%%%%%   %%%%%%%     %%   '),nl,
write('  %%        %%%%%%%%  %%        %%    %%  %%        %%%%%%%    %%%%%%%    %%   '),nl,
write('  %%        %%    %%  %%        %%    %%  %%        %%    %%        %%    %%   '),nl,
write('  %%        %%    %%  %%         %%  %%   %%        %%    %%        %%    %%   '),nl,
write('  %%%%%%%%  %%    %%  %%%%%%%%    %%%%    %%%%%%%%  %%    %%  %%%%%%%% %%%%%%%%'),nl,
write('  %%%%%%%%  %%    %%  %%%%%%%%     %%     %%%%%%%%  %%    %%  %%%%%%%  %%%%%%%%'),nl,
write('                   Written by Andre Goncalves and Damien Rosa'),
nl,nl.


%***************************************************************************
%*                                                                         *
%*                           SERVIDOR SOCKETS                              *
%*                                                                         *
%***************************************************************************

port(60070).

server:-
	port(Port),
	socket_server_open(Port, Socket),
	socket_server_accept(Socket, _Client, Stream, [type(text)]),
	write('Accepted connection'), nl,
	serverLoop(Stream),
	socket_server_close(Socket).

% wait for commands
serverLoop(Stream) :-
	repeat,
	read(Stream, ClientMsg),
	write('Received: '), write(ClientMsg), nl,
	server_input(ClientMsg, MyReply),
	format(Stream, '~q.~n', [MyReply]),
	write('Wrote: '), write(MyReply), nl,
	flush_output(Stream),
	(ClientMsg == quit; ClientMsg == end_of_file), !.

server_input(initialize, Board) :- initBoard(Board), viewTab(Board), !.

server_input(continueMove(Player, Tab, X, Y, Piece, L, N), EndBoard) :-
	continueMove(Player, EndBoard, X, Y, Piece, L, N), !.

server_input(isPossible(Tab, X, Y, Piece, LX, LY, N, Bool), NBool) :-
	isPossible(Tab, X, Y, Piece, LX, LY, N, NBool), !.
	
server_input(bye, ok):-!.

server_input(end_of_file, ok):-!.

server_input(_, invalid) :- !.	