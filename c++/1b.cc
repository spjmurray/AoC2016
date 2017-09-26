#include <stdlib.h>
#include <string>
#include <sstream>
#include <vector>
#include <iostream>
#include <set>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>

using namespace std;

class CycleIterator {
public:
  CycleIterator(unsigned int size)
  : size(size), curr(0)
  {}

  void operator++(int) {
    curr++;
    curr %= size;
  }

  void operator--(int) {
    curr--;
    curr %= size;
  }

  unsigned int operator*() const {
    return curr;
  }

private:
  unsigned int size;
  unsigned int curr;
};

class Vector2i {
public:
  Vector2i(int x = 0, int y = 0)
  : x(x), y(y)
  {}

  inline Vector2i& operator+=(const Vector2i& v) {
    x += v.x;
    y += v.y;
    return *this;
  }

  inline Vector2i operator*(unsigned int i) const {
    return Vector2i(x * i, y * i);
  }

  inline unsigned int manhattan() const {
    return ::abs(x) + ::abs(y);
  };

  inline bool operator<(const Vector2i& v) const {
    if(x != v.x)
      return x < v.x;
    return y < v.y;
  }

  int x;
  int y;
};

int main() {
  string input("R4, R5, L5, L5, L3, R2, R1, R1, L5, R5, R2, L1, L3, L4, R3, L1, L1, R2, R3, R3, R1, L3, L5, R3, R1, L1, R1, R2, L1, L4, L5, R4, R2, L192, R5, L2, R53, R1, L5, R73, R5, L5, R186, L3, L2, R1, R3, L3, L3, R1, L4, L2, R3, L5, R4, R3, R1, L1, R5, R2, R1, R1, R1, R3, R2, L1, R5, R1, L5, R2, L2, L4, R3, L1, R4, L5, R4, R3, L5, L3, R4, R2, L5, L5, R2, R3, R5, R4, R2, R1, L1, L5, L2, L3, L4, L5, L4, L5, L1, R3, R4, R5, R3, L5, L4, L3, L1, L4, R2, R5, R5, R4, L2, L4, R3, R1, L2, R5, L5, R1, R1, L1, L5, L5, L2, L1, R5, R2, L4, L1, R4, R3, L3, R1, R5, L1, L4, R2, L3, R5, R3, R1, L3");

  vector<string> inputs;
  boost::split(inputs, input, boost::is_any_of(", "), boost::token_compress_on);

  Vector2i position;

  const Vector2i moves[4] = {Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)};
  CycleIterator i(4);

  set<Vector2i> visited;

  bool done = false;
  for(auto move = inputs.begin(); move != inputs.end() && !done; move++) {
    char direction;
    unsigned int magnitude;
    istringstream stream(*move);
    stream >> direction >> magnitude;

    if(direction == 'R')
      i++;
    else
      i--;

    for(unsigned int j = 0; j < magnitude; j++) {
      position += moves[*i];
      if(visited.find(position) != visited.end()) {
        done = true;
        break;
      }
      visited.insert(position);
    }
  }

  cout << position.manhattan() << endl;

  return 0;
}
