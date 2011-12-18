#include "Socket.h"
#include <vector>
#include <string>

using namespace std;

string vectorToChar(const vector<string> &board);
vector<string> CharToVector(string boardProl);
string continueMove(string player, int x, int y, string boardProl,string piece, string hand, int itera);
string isPossible(string tab, int x, int y, string piece, int newX, int newY, int itera);

