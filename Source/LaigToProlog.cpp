#include <string>
#include <vector>
#include <iostream>
#include <sstream>

using namespace std;

int boardSize = 8;

//c++ to prolog
string vectorToChar(const vector<string> &board) {
	stringstream arrayResult;

	arrayResult << "[";
	int j = 0;
	for (int i = 1; i < boardSize + 1; i++) {
		arrayResult << "[";

		for (; j < i * boardSize; j++) {
			arrayResult << "'" << board[j];
			if (j == 7 || j == 15 || j == 23 || j == 31 || j == 39 || j == 47
					|| j == 55 || j == 63) {
				arrayResult << "'";
			} else {
				arrayResult << "',";
			}
		}

		if (i == 0)
			j = i * boardSize;

		if ((unsigned int) i == boardSize)
			arrayResult << "]";
		else
			arrayResult << "],";

	}
	arrayResult << "]";

	return arrayResult.str();
}

vector<string> CharToVector(string boardProl) {
	vector<string> vec;
	unsigned int i = 0;
	while (i != boardProl.size()) {
		string c;
		if (boardProl[i] != '[' && boardProl[i] != ']' && boardProl[i] != '\''
				&& boardProl[i] != ',') {

			if (boardProl[i] == ' ' && boardProl[i + 1] == ' '
					&& boardProl[i + 2] == ' ') {
				c = "   ";
			} else if (boardProl[i] == ' ' && boardProl[i + 1] == 'X'
					&& boardProl[i + 2] == ' ') {
				c = " X ";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'k'
					&& boardProl[i + 2] == 'i') {
				c = "wki";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'q'
					&& boardProl[i + 2] == 'u') {
				c = "wqu";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'r'
					&& boardProl[i + 2] == '1') {
				c = "wr1";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'r'
					&& boardProl[i + 2] == '2') {
				c = "wr2";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'k'
					&& boardProl[i + 2] == '1') {
				c = "wk1";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'k'
					&& boardProl[i + 2] == '2') {
				c = "wk2";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'b'
					&& boardProl[i + 2] == '1') {
				c = "wb1";
			} else if (boardProl[i] == 'w' && boardProl[i + 1] == 'b'
					&& boardProl[i + 2] == '2') {
				c = "wb2";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'k'
					&& boardProl[i + 2] == 'i') {
				c = "bki";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'q'
					&& boardProl[i + 2] == 'u') {
				c = "bqu";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'r'
					&& boardProl[i + 2] == '1') {
				c = "br1";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'r'
					&& boardProl[i + 2] == '2') {
				c = "br2";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'k'
					&& boardProl[i + 2] == '1') {
				c = "bk1";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'k'
					&& boardProl[i + 2] == '2') {
				c = "bk2";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'b'
					&& boardProl[i + 2] == '1') {
				c = "bb1";
			} else if (boardProl[i] == 'b' && boardProl[i + 1] == 'b'
					&& boardProl[i + 2] == '2') {
				c = "bb2";
			}

			vec.push_back(c);

		}
		i++;
	}
	return vec;
}

string continueMove(string player, int x, int y, string boardProl, string piece, string hand, int itera){
	stringstream ss;
	ss << "continueMove(" << player << "," << boardProl << "," << x << "," << y << "," << piece << "," << hand << "," << itera << ").";  
	return ss.str();
}

string isPossible(string tab, int x, int y, string piece, int newX, int newY, int itera){
	stringstream ss;
	bool t;
	ss << "isPossible(" << tab << "," << x << "," << y << "," << piece << "," << newX << "," << newY << "," << itera << "," << t << ").";
	return ss.str();
}
