% Buffalo em Prolog
% Por: Alexandre Perez, João Santos, Vitor Oliveira

:-use_module(library(lists)).
:-use_module(library(random)).
:-use_module(library(sockets)).

/******************************************************************************/
/*                                                                            */
/*                        Estado Inicial do Tabuleiro                         */
/*                                                                            */
/******************************************************************************/
estado_inicial([[1,1,1,1,1,1,1,1,1,1,1],
               [0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,3,3,2,3,3,0,0,0],
               [9,9,9,9,9,9,9,9,9,9,9]]).

/******************************************************************************/
/*                                                                            */
/*                        Visualização do Tabuleiro                           */
/*                                                                            */
/******************************************************************************/
visualiza(Tabuleiro):-
          nl, write('    A   B   C   D   E   F   G   H   I   J   K'), nl,
          separador(11),
          linhas_tabuleiro(1, Tabuleiro), nl,!.

linhas_tabuleiro(_, []).
linhas_tabuleiro(N, [L|Resto]):-  (N == 1; N == 6), write(' '),
          write(N), linha_tabuleiro(L),write('|'), nl,
          separador_rio(11),
          N2 is N + 1,
          linhas_tabuleiro(N2, Resto).

linhas_tabuleiro(N, [L|Resto]):-  N \= 1, N \= 6 ,   write(' '),
          write(N), linha_tabuleiro(L),write('|'), nl,
          separador(11),
          N2 is N + 1,
          linhas_tabuleiro(N2, Resto).

seccao_separador(0, _).
seccao_separador(N, 0):- N1 is N - 1, write('---+'), seccao_separador(N1,0).
seccao_separador(N, 1):- N1 is N - 1, write('~~~+'), seccao_separador(N1,1).
separador(N):- write('  +'), seccao_separador(N, 0), nl.
separador_rio(N):- write('  +'), seccao_separador(N, 1), nl.

linha_tabuleiro([]).
linha_tabuleiro([E|Resto]):-
          write('| '),escreve(E),  write(' '),
          linha_tabuleiro(Resto).

escreve(0):- write(' ').
escreve(1):- write('B').
escreve(2):- write('I').
escreve(3):- write('C').
escreve(9):- write(' ').


/******************************************************************************/
/*                                                                            */
/*                        Manipulação do Tabuleiro                            */
/*                                                                            */
/******************************************************************************/
membrotab(Pec,X,Y,Tab):-
        membro_pos_lista(Linha, Y, Tab),
        membro_pos_lista(Pec, X, Linha).

membro_pos_lista(Membro, N, Lista):-
        membro_pos_procura(Membro, 1, N, Lista).

membro_pos_procura(Membro, N, N, [Membro|_]).
membro_pos_procura(Membro, P, N, [_|T]):-
        P2 is P+1,
        membro_pos_procura(Membro, P2, N, T).

dentro(X,Y):- X>=1, X=<11, Y>=2, Y=<7.

vizinho(X,Y,Xv,Yv, se):- Xv is X+1, Yv is Y+1, dentro(Xv,Yv).
vizinho(X,Y,Xv,Yv, sw):- Xv is X-1, Yv is Y+1, dentro(Xv,Yv).
vizinho(X,Y,Xv,Yv, ne):- Xv is X+1, Yv is Y-1, dentro(Xv,Yv).
vizinho(X,Y,Xv,Yv, nw):- Xv is X-1, Yv is Y-1, dentro(Xv,Yv).
vizinho(X,Y,Xv,Yv, e):- Xv is X+1, Yv is Y, dentro(Xv,Yv).
vizinho(X,Y,Xv,Yv, w):- Xv is X-1, Yv is Y, dentro(Xv,Yv).
vizinho(X,Y,Xv,Yv, s):- Xv is X, Yv is Y+1, dentro(Xv,Yv).
vizinho(X,Y,Xv,Yv, n):- Xv is X, Yv is Y-1, dentro(Xv,Yv).


muda_tab(Peca,Pnov,X,Y,Tab,NovoTab):-
        muda_tab2(1,Peca,Pnov,X,Y,Tab,NovoTab),!.

muda_tab2(_,_,_,_,_,[],[]).
muda_tab2(Y,Peca,Pnov,X,Y,[Lin|Resto],[NovLin|Resto2]):-
        muda_linha(1,Peca,Pnov,X,Lin,NovLin),
        N2 is Y+1,
        muda_tab2(N2,Peca,Pnov,X,Y,Resto,Resto2).
muda_tab2(N,Peca,Pnov,X,Y,[Lin|Resto],[Lin|Resto2]):-
        N\=Y, N2 is N+1,
        muda_tab2(N2,Peca,Pnov,X,Y,Resto,Resto2).

muda_linha(_,_,_,_,[],[]).
muda_linha(X,Peca,Pnov,X,[Peca|Resto],[Pnov|Resto2]):-
        N2 is X+1,
        muda_linha(N2,Peca,Pnov,X,Resto,Resto2).
muda_linha(N,Peca,Pnov,X,[El|Resto],[El|Resto2]):-
        N\=X, N2 is N+1,
        muda_linha(N2,Peca,Pnov,X,Resto,Resto2).


/******************************************************************************/
/*                                                                            */
/*                        Validação e Execução de Movimentos                  */
/*                                                                            */
/******************************************************************************/
%mov_buffalo:- valida, muda_peca, muda_peca
executa_peca(Peca, X, Y, Xf, Yf, TabAntigo, TabNovo):-
              ((Peca=1,
                executa_jogada(buffalo,X, Y, Xf, Yf, TabAntigo, TabNovo));
              executa_jogada(indio, X, Y, Xf, Yf, TabAntigo, TabNovo)).
              
executa_jogada(buffalo, X,Y,_,_, TabAntigo, TabNovo):-
              mov_buffalo(X,Y,TabAntigo,TabNovo).

executa_jogada(indio, X, Y, Xf, Yf, TabAntigo, TabNovo):-
              mov_indio(X,Y,Xf,Yf,TabAntigo,TabNovo).

mov_buffalo(X,1, TabAntigo, TabNovo):-
              muda_tab(1,9,X,Y,TabAntigo,TabTemp),
              Y1 is Y + 1,
              muda_tab(_,1,X,Y1,TabTemp,TabNovo).

mov_buffalo(X,Y, TabAntigo, TabNovo):-
              Y\=1,
              muda_tab(1,0,X,Y,TabAntigo,TabTemp),
              Y1 is Y + 1,
              muda_tab(_,1,X,Y1,TabTemp,TabNovo).

mov_indio(X,Y,Xf,Yf, TabAntigo, TabNovo):-
              muda_tab(Peca,0,X,Y, TabAntigo, TabTemp),
              muda_tab(_,Peca,Xf,Yf,TabTemp, TabNovo).

livre(Xf,Yf,Xf,Yf,_,_).
livre(X,Y,Xf,Yf,Dir,Tab):- vizinho(X,Y,X2,Y2,Dir) ,
              membrotab(0,X2,Y2,Tab), livre(X2,Y2,Xf,Yf,Dir,Tab).

valida_peca(Peca,X,Y,Xf,Yf,Tab):- ((Peca=1, valida_buffalo(X,Y,Tab));
              valida_indio(Peca,X,Y,Xf,Yf,Tab)).

valida_buffalo(X,Y,Tab):- Y1 is Y + 1,
              (membrotab(0,X,Y1,Tab);membrotab(9,X,Y1,Tab)).

valida_indio(3,X,Y,Xf,Yf,Tab):- livre(X,Y,Xf,Yf,_,Tab), (X\=Xf;Y\=Yf).
valida_indio(2,X,Y,Xf,Yf,Tab):- vizinho(X,Y,Xf,Yf,_) ,
              membrotab(Peca,Xf,Yf,Tab), (Peca==0;Peca==1), (X\=Xf;Y\=Yf).


determina_jogada(humano, buffalo, X, Y,_,_, Tab):-
              repeat, pede_jogada(buffalo, X),
              membrotab(1,X,Y,Tab),
              valida_buffalo(X,Y,Tab).

determina_jogada(comp, buffalo, X, Y, _, _, Tab):-
              write('O computador vai jogar o buffalo'), read_line(_),
              nivel(buffalo, Nivel),
              calcula_jogada(Nivel, buffalo, X,Y,_,_,Tab).

determina_jogada(humano, indio, X, Y, Xf, Yf, Tab):-
              repeat, pede_jogada(indio, X, Y, Xf, Yf),
              membrotab(Peca,X,Y,Tab),(Peca==2;Peca==3),
              valida_indio(Peca, X, Y, Xf, Yf, Tab).

determina_jogada(comp, indio, X, Y, Xf, Yf, Tab):-
              nivel(indio, Nivel),
              calcula_jogada(Nivel, indio, X,Y,Xf,Yf,Tab),
              write('O computador vai jogar o indio'), read_line(_).

pede_jogada(buffalo, X):-
              write('Escreva a coluna do buffalo a mover (Ex.: A): '),
              read_line([SX]), conv(SX,X).
pede_jogada(indio,X,Y,Xf,Yf):-
              write('Escreva as coordenadas do indio a mover(Ex.: D6 A3): '),
              read_line([SX,SY,_,SXf,SYf]),
              conv(SX,X), conv(SXf,Xf), conv(SY,Y), conv(SYf,Yf).

conv(SX,X):- SX>=65, SX=<75, X is SX - 64.
conv(SX,X):- SX>=97, SX=<107, X is SX - 96.
conv(SY,Y):- SY>=49, SY=<57, Y is SY - 48.

/******************************************************************************/
/*                                                                            */
/*                        Inicio do Programa                                  */
/*                                                                            */
/******************************************************************************/

inicio:-
      titulo,
      tipo_jogo, nivel_comp(indio), nivel_comp(buffalo),
      estado_inicial(Tab),
      nl, write('Tabuleiro inicial:'),
      visualiza(Tab),
      tipo_jogador(buffalo, Buffalo),
      jogada(Buffalo, buffalo, Tab).

jogada(Tipo,Jogador, Tab):-
      determina_jogada(Tipo, Jogador, X, Y, Xf, Yf, Tab), !,
      executa_jogada(Jogador, X, Y, Xf, Yf, Tab, Tab2),
      visualiza(Tab2),
      (fim_do_jogo(Tab2, Venc);continua(Jogador, Tab2)).

prox_jogador(indio, buffalo).
prox_jogador(buffalo, indio).

fim_do_jogo(Tab, Venc):-
        ( no_buffalos(Tab,Venc); ganhou_buffalo(Tab, Venc);
          buffalo_preso(Tab, Venc) ),
        !, mensagem_vitoria(Venc).

mensagem_vitoria(Venc):- write('Ganhou o '),write(Venc),('!'), nl.

no_buffalos(Tab,_):- membrotab(1,_,_,Tab), !, fail.
no_buffalos(_, indio).

ganhou_buffalo(Tab, buffalo):- membrotab(1, _,7,Tab).

buffalo_preso(Tab, _):- membrotab(1,X,Y,Tab),valida_buffalo(X,Y,Tab),!,fail.
buffalo_preso(_, indio).

continua(Jogador, Tab):-
      prox_jogador(Jogador, Seguinte),
      tipo_jogador(Seguinte, Tipo),
      jogada(Tipo, Seguinte, Tab).
      
titulo:-
write('  %%%%%%    %%    %%  %%%%%%%%  %%%%%%%%    %%%%    %%          %%%%  '),
nl,
write('  %%%%%%%   %%    %%  %%%%%%%%  %%%%%%%%   %%%%%%   %%         %%%%%% '),
nl,
write('  %%   %%%  %%    %%  %%        %%        %%%  %%%  %%        %%%  %%%'),
nl,
write('  %%    %%  %%    %%  %%        %%        %%    %%  %%        %%    %%'),
nl,
write('  %%   %%%  %%    %%  %%        %%        %%    %%  %%        %%    %%'),
nl,
write('  %%%%%%%   %%    %%  %%%%%     %%%%%     %%%%%%%%  %%        %%    %%'),
nl,
write('  %%   %%%  %%    %%  %%        %%        %%    %%  %%        %%    %%'),
nl,
write('  %%    %%  %%    %%  %%        %%        %%    %%  %%        %%    %%'),
nl,
write('  %%   %%%  %%%  %%%  %%        %%        %%    %%  %%        %%%  %%%'),
nl,
write('  %%%%%%%    %%%%%%   %%        %%        %%    %%  %%%%%%%%   %%%%%% '),
nl,
write('  %%%%%%      %%%%    %%        %%        %%    %%  %%%%%%%%    %%%%  '),
nl, write('      Realizado por Alexandre Perez, João Santos e Vitor Oliveira'),
nl,nl.

tipo_jogo:-
      abolish(tipo_jogador/2), abolish(nivel/2),
      write('Escolha o modo de jogo:'), nl,
      write('  1: Buffalo - Humano ; Indio - Humano'), nl,
      write('  2: Buffalo - Humano ; Indio - Comp'), nl,
      write('  3: Buffalo - Comp   ; Indio - Humano'), nl,
      write('  4: Buffalo - Comp   ; Indio - Comp'), nl,
      repeat, read_line([SX]), conv_tipo(SX, Buffalo, Indio),
      assert(tipo_jogador(buffalo, Buffalo)),
      assert(tipo_jogador(indio, Indio)).

nivel_comp(Jogador):-
      tipo_jogador(Jogador, comp), !,
      repeat, write('Nivel de dificuldade do '), write(Jogador),
      write(' [1 - Aleatorio, 2 - Inteligente]: '),
      read_line([SX]), conv_nivel(SX, Nivel), assert(nivel(Jogador, Nivel)).
nivel_comp(_).

conv_tipo(49, humano, humano).
conv_tipo(50, humano, comp).
conv_tipo(51, comp, humano).
conv_tipo(52, comp, comp).

conv_nivel(49, aleatorio).
conv_nivel(50, inteligente).

/******************************************************************************/
/*                                                                            */
/*                        Calculo da Jogada do Computador                     */
/*                                                                            */
/******************************************************************************/
calcula_jogada(aleatorio, buffalo, X, Y,Xf,Yf,Tab):-
        findall(X1-Y1,(membrotab(1,X1,Y1,Tab),
                       valida_buffalo(X1,Y1,Tab)), Lista ),
        escolhe_elemento_buffalo2(X,Y,Lista),
        Xf is X, Yf is Y + 1.

calcula_jogada(inteligente, buffalo, X, Y, Xf,Yf,Tab):-
        findall(Val1-X1-Y1,(membrotab(1,X1,Y1,Tab),
                            valida_buffalo(X1,Y1,Tab),
                            avalia_buffalo(X1,Y1,Tab, Val1)), Lista ),
        escolhe_buffalo(X,Y,Lista),
        Xf is X, Yf is Y + 1.

avalia_buffalo(_,6,_,1):- !.
avalia_buffalo(X,5,Tab, 2):-
        avalia_buffalo_aux(X,5,Tab), !.
avalia_buffalo(X,5,Tab, 3):- livre(X,5,X,6,_,Tab), !.
avalia_buffalo(X,4,Tab, 4):-
        avalia_buffalo_aux(X,4,Tab), !.
avalia_buffalo(X,4,Tab, 5):- livre(X,4,X,6,_,Tab), !.
avalia_buffalo(X,Y,Tab, 6):-
        avalia_buffalo_aux(X,Y,Tab), !.
avalia_buffalo(X,Y,Tab, 7):- livre(X,Y,X,6,_,Tab), !.
avalia_buffalo(X,Y,Tab, 8):- membrotab(3,X,Y1,Tab), Y1 > Y, !.
avalia_buffalo(X,Y,Tab, 9):- membrotab(2,X,Y1,Tab),Y1 > Y, !.
avalia_buffalo(_,_,_,10):- !.

avalia_buffalo_aux(X,Y,Tab):-
        Y1 is Y + 1, findall(X1, (membrotab(2,X1,Y3,Tab),
                                  valida_indio(2,X1,Y3,X,Y1,Tab)), Lista1),
        Lista1 = [],
        Y2 is Y + 2, findall(X2, (membrotab(2,X2,Y4,Tab),
                                  valida_indio(2,X2,Y4,X,Y1,Tab)), Lista2),
        Lista2 = [],
        findall(X3, (membrotab(3,X3,Y5,Tab),
                     valida_indio(3,X3,Y5,X,Y2,Tab)), Lista3),
        Lista3 = [], livre(X,Y,X,6,_,Tab).
        
escolhe_buffalo(X,Y,Lista):-
        keysort(Lista, Lista2), Lista2=[Val-X1-Y1|_],
        remove_elementos_buffalo(Val, Lista2,[], Lista3),
        escolhe_elemento_buffalo(X,Y,Lista3).

remove_elementos_buffalo(_, [], Acc, Acc):- !.
remove_elementos_buffalo(Val,[Val2-X-Y|Resto],Acc, Acc):- Val \= Val2, !.
remove_elementos_buffalo(Val, [Val-X-Y|Resto], Lista, Lista2):-
        remove_elementos_buffalo(Val, Resto, [Val-X-Y|Lista], Lista2).

escolhe_elemento_buffalo2(X,Y,Lista):-
        length(Lista, Num),Num2 is Num + 1,
        random(1, Num2, Rand),
        nth1(Rand, Lista, X-Y).

escolhe_elemento_buffalo(X,Y,Lista):-
        length(Lista, Num),Num2 is Num + 1,
        random(1, Num2, Rand),
        nth1(Rand, Lista, Val-X-Y).

escolhe_elemento_indio2(X,Y,Xf,Yf,Lista):-
        length(Lista, Num), Num2 is Num + 1,
        random(1, Num2, Rand),
        nth1(Rand, Lista, Val-X-Y-Xf-Yf).

calcula_jogada(aleatorio, indio, X, Y, Xf, Yf, Tab):-
        random(1, 4, Rand),
        (Rand = 1, findall(Val1-X1-Y1-Xf1-Yf1,(membrotab(2,X1,Y1,Tab),
                   valida_indio(2,X1,Y1,Xf1,Yf1,Tab)), Lista ),
                   escolhe_elemento_indio2(X,Y,Xf,Yf,Lista);
        findall(Val1-X1-Y1-Xf1-Yf1,(membrotab(3,X1,Y1,Tab),
                   valida_indio(3,X1,Y1,Xf1,Yf1,Tab)), Lista ),
                   escolhe_elemento_indio2(X,Y,Xf,Yf,Lista)).

calcula_jogada(inteligente, indio, X, Y, Xf, Yf, Tab):-
        findall(Val1-X1-Y1-Xf1-Yf1,(membrotab(2,X1,Y1,Tab),
                valida_indio(2,X1,Y1,Xf1,Yf1,Tab),
                avalia_indio(2,X1,Y1,Xf1,Yf1,Tab,Val1)), Lista ),
        findall(Val2-X2-Y2-Xf2-Yf2,(membrotab(3,X2,Y2,Tab),
                valida_indio(3,X2,Y2,Xf2,Yf2,Tab),
                avalia_indio(3,X2,Y2,Xf2,Yf2,Tab,Val2)), Lista2 ),
        concatena(Lista,Lista2,Lista3),
        keysort(Lista3,Lista4),
        escolhe_indio(X,Y,Xf,Yf,Lista4).


escolhe_indio(X,Y,Xf,Yf,Lista):-
        keysort(Lista, Lista2), Lista2=[Val-X1-Y1-Xf1-Yf1|_] ,
        remove_elementos_indio(Val, Lista2,[], Lista3),
        escolhe_elemento_indio2(X,Y,Xf,Yf,Lista3).

remove_elementos_indio(_, [], Acc, Acc):- !.
remove_elementos_indio(Val,[Val2-X-Y-Xf-Yf|Resto],Acc, Acc):- Val \= Val2, !.
remove_elementos_indio(Val, [Val-X-Y-Xf-Yf|Resto], Lista, Lista2):-
        remove_elementos_indio(Val, Resto, [Val-X-Y-Xf-Yf|Lista], Lista2).

nao(Termo):-Termo,!,fail.
nao(_).

%Indio come Buffalo que esta antes do rio
avalia_indio(2,X,Y,Xf,6,Tab,1):-
        membrotab(2,X,Y,Tab), vizinho(X,Y,Xf,6,_), membrotab(1,Xf,6,Tab),!.

%Indio come Buffalo que esta em y=5
avalia_indio(2,X,Y,Xf,5,Tab,2):-
        membrotab(2,X,Y,Tab), vizinho(X,Y,Xf,5,_),
        membrotab(1,Xf,5,Tab), membrotab(0,Xf,6,Tab),
        nao((membrotab(3,Xf,Y1,Tab), Y1 < 5)),!.

%Cao que esta sem buffalos a frente tapa Buffalo que esta em Y=5
avalia_indio(3,X,Y,Xf,6,Tab,3):-
        membrotab(3,X,Y,Tab),
        nao((membrotab(1,X,Y1,Tab))),
        membrotab(1,Xf,5,Tab),!.

%Cao que esta mais acima tenta tapar o Buffalo que esta na casa Y=5
avalia_indio(3,X,Y,Xf,6,Tab,4):-
        membrotab(3,X,Y,Tab), membrotab(1,Xf,5,Tab),
        ((membrotab(0,X,5,Tab));(membrotab(3,X,5,Tab));(membrotab(2,X,5,Tab));
        (vizinho(X,6,X2,Y2,_),membrotab(2,X2,Y2,Tab))),
        setof(Y1-X1, (membrotab(3,X1,Y1,Tab),
                      valida_indio(3,X1,Y1,Xf,6,Tab)),Lista),
        Lista = [Y-X|_],!.

%Indio come Buffalo que esta em y=4
avalia_indio(2,X,Y,Xf,4,Tab,5):-
        membrotab(2,X,Y,Tab), vizinho(X,Y,Xf,4,_), membrotab(1,Xf,4,Tab),!.

%Cao que nao tem Buffalos a frente tenta bloquear Buffalo em Y=4
%em 1 jogada
avalia_indio(3,X,Y,Xf,Yf,Tab,6):-
        membrotab(3,X,Y,Tab),
        nao(membrotab(1,X,Y1,Tab)),
        livre(Xf,4,Xf,6,_,Tab),
        membrotab(1,Xf,4,Tab), Yf > 4, !.

%Cao tenta bloquear Buffalo em Y=4 em 1 jogada
avalia_indio(3,X,Y,Xf,Yf,Tab,7):-
         membrotab(3,X,Y,Tab), membrotab(1,Xf,4,Tab), livre(Xf,4,Xf,6,_,Tab),
         valida_indio(3,X,Y,Xf,Yf,Tab), Yf > 4, membrotab(1,X,Yb,Tab), Yb < 4,!.

%Cao que nao tem Buffalos a frente tenta bloquear Buffalo em Y=4
%em 2 jogadas
avalia_indio(3,X,Y,Xf,Yf,Tab,8):-
        membrotab(3,X,Y,Tab), nao(membrotab(1,X,Y1,Tab)),
        membrotab(1,X1,4,Tab), livre(X1,4,X1,6,_,Tab),
        setof(Y2-X2, (membrotab(3,X2,Y2,Tab), valida_indio(3,X2,Y2,Xf,Yf,Tab),
                      executa_jogada(indio, X2, Y2, Xf, Yf, Tab, TabNovo),
                      valida_indio(3,Xf,Yf,X1,6,TabNovo)),Lista2),
        Lista2 = [Y-X|_],!.

%Cao tenta bloquear Buffalo em Y=4 em 2 jogadas
avalia_indio(3,X,Y,Xf,Yf,Tab,9):-
        membrotab(3,X,Y,Tab), membrotab(1,X1,4,Tab),  livre(X1,4,X1,6,_,Tab),
        membrotab(1,X,Yb,Tab), Yb < 4,
        setof(Y2-X2, (membrotab(3,X2,Y2,Tab), valida_indio(3,X2,Y2,Xf,Yf,Tab),
                      executa_jogada(indio, X2, Y2, Xf, Yf, Tab, TabNovo),
                      valida_indio(3,Xf,Yf,X1,6,TabNovo)),Lista2),
        Lista2 = [Y-X|_],!.

%Indio come o Buffalo vizinho abaixo dele
avalia_indio(2,X,Y,Xf,Yf,Tab,10):-
        membrotab(2,X,Y,Tab), Y < Yf,
        vizinho(X,Y,Xf,Yf,_),membrotab(1,Xf,Yf,Tab),!.

%Indio come Buffalo vizinho
avalia_indio(2,X,Y,Xf,Yf,Tab,11):-
        membrotab(2,X,Y,Tab),vizinho(X,Y,Xf,Yf,_),membrotab(1,Xf,Yf,Tab),!.

%Indio avanca para o Buffalo nao bloqueado mais proximo
avalia_indio(2,X,Y,Xf,Yf,Tab,12):- membrotab(2,X,Y,Tab),
        findall(Dist-X1-Y1,(membrotab(1,X1,Y1,Tab), A is abs(X-X1),
              B is abs(Y-Y1), Y1 >= 2, calcula_diagonal(A,B,Dist)),
              Lista), keysort(Lista,Lista3),
        Lista3 = [Dist2-X2-Y2|_], nao((membrotab(3,X2,Y3,Tab), Y3 > Y2)),
        direccao_indio(X,Y,X2,Y2,Xf,Yf),!.

%Indio avanca para o Buffalo mais proximo
avalia_indio(2,X,Y,Xf,Yf,Tab,13):- membrotab(2,X,Y,Tab),
        findall(Dist-X1-Y1,(membrotab(1,X1,Y1,Tab), A is abs(X-X1),
              B is abs(Y-Y1), Y1 >= 2, calcula_diagonal(A,B,Dist)),
              Lista), keysort(Lista,Lista3),
        Lista3 = [Dist2-X2-Y2|_], direccao_indio(X,Y,X2,Y2,Xf,Yf),!.

%Cao bloqueia caminho a Buffalo mais proximo do rio
avalia_indio(3,X,Y,Xf,Yf,Tab,14):- membrotab(3,X,Y,Tab),
        nao(membrotab(1,X,Y1,Tab)),
        membrotab(1, Xf, Y2, Tab), livre(Xf,Y2,Xf,6,_,Tab), Yf < Y2,!.

%Cao avança para o Buffalo a sua frente
avalia_indio(3,X,Y,X,Yf,Tab,15):- membrotab(3,X,Y,Tab),
        setof(Y1, membrotab(1,X,Y1,Tab), Lista),
        reverse(Lista, Lista2), Lista2 = [Y2|_], Yf is Y2+1,!.

avalia_indio(Peca,X,Y,Xf,Yf,Tab,16):-!.

direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 > X, Y1 > Y, Xf is X+1, Yf is Y+1,!.
direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 < X, Y1 < Y, Xf is X-1, Yf is Y-1,!.
direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 > X, Y1 < Y, Xf is X+1, Yf is Y-1,!.
direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 < X, Y1 > Y, Xf is X-1, Yf is Y+1,!.
direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 > X, Y1 = Y, Xf is X+1, Yf is Y,!.
direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 = X, Y1 < Y, Xf is X, Yf is Y-1,!.
direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 < X, Y1 = Y, Xf is X-1, Yf is Y,!.
direccao_indio(X,Y,X1,Y1,Xf,Yf):- X1 = X, Y1 > Y, Xf is X, Yf is Y+1,!.
direccao_indio(X,Y,X,Y,X,Y).

calcula_diagonal(A,B,Dist):- Dist is max(A,B),!.

concatena([],L,L).
concatena([X|L1],L2,[X|L3]):- concatena(L1,L2,L3).

/******************************************************************************/
/*                                                                            */
/*                        Servidor                                            */
/*                                                                            */
/******************************************************************************/
port(60001).

server:-
        port(Port),
        socket_server_open(Port,Socket),
        socket_server_accept(Socket, _Client, Stream, [type(text)]),
        server_loop(Stream),
        socket_server_close(Socket),
        write('Server Exit'),nl.

server_loop(Stream) :-
        repeat,
                read(Stream, ClientRequest),
                write('Received: '), write(ClientRequest), nl,
                server_input(ClientRequest, ServerReply),
                format(Stream, '~q.~n', [ServerReply]),
                write('Send: '), write(ServerReply), nl,
                flush_output(Stream),
        (ClientRequest == bye; ClientRequest == end_of_file), !.

server_input(initialize, ok(Board)):-
        estado_inicial(Board), !.
server_input(execute(Peca,X,Y,Xf,Yf,Board), ok(NewBoard)):-
        valida_peca(Peca,X,Y,Xf,Yf,Board),
        executa_peca(Peca,X,Y,Xf,Yf,Board,NewBoard), !.
server_input(calculate(Level, J, Board), ok(X,Y,Xf,Yf, NewBoard)):-
        calcula_jogada(Level, J, X,Y,Xf,Yf,Board),
        executa_peca(Peca,X,Y,Xf,Yf,Board,NewBoard), !.
server_input(game_end(Board), ok(Winner)):-
        fim_do_jogo(Board, Winner), !.
server_input(bye, ok):-!.
server_input(end_of_file, ok):-!.
server_input(_, invalid) :- !.
