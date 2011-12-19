#include <winsock2.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <vector>

/*
#define MAX_MESSAGE_SIZE 512
#define BOARD_DIMENSION 10*/

using namespace std;

bool socketConnect(char *host, char *port);
void sendMessage(char *s, int len);
void receiveMessage( char *ans);
void quit();
bool readBoardCheck(char* s, vector<string> board);