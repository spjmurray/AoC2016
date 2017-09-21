#include <set>
#include <list>
#include <algorithm>
#include <iostream>
#include <vector>

// Constants identifying which element in an ElementPair we are refering to
const unsigned int GENERATOR = 0;
const unsigned int CHIP      = 1;

// A pair of element objects i.e. generator and chip
typedef std::pair<unsigned int, unsigned int> ElementPair;

// A collection on element objects and pairs
typedef std::vector<ElementPair> Elements;

class State {
public:
  State(const Elements& elements, unsigned int floor = 0, unsigned int distance = 0)
  : elements(elements), floor(floor), distance(distance), guid(-1)
  {}

  // The Guid should be a globally unique state identifier with quick comparison
  long getGuid() {
    if(guid >= 0) {
      return guid;
    }
    // Colate elements into an array of generator/chip nibbles
    std::vector<unsigned int> pairs;
    for(auto i = elements.begin(); i != elements.end(); i++)
      pairs.emplace_back((*i).first << 4 | (*i).second);
    // Sort so that we only care about relative positions of generators and chips
    std::sort(pairs.begin(), pairs.end());
    // Create the GUID state by concatenating the floor and sorted relative positions
    guid = floor;
    for(auto i = pairs.begin(); i != pairs.end(); i++) {
      guid <<= 8; guid |= *i;
    }
    return guid;
  }

  // Get the distance travelled
  unsigned int getDistance() const {
    return distance;
  }

  // Is this state the final one?
  bool done() const {
    for(auto i = elements.begin(); i != elements.end(); i++)
      if((*i).first != 3 || (*i).second != 3)
        return false;
    return true;
  }

  // Given a reference to a state list, populate it with valid next moves
  void getMoves(std::list<State*>& moves) const {
    // Get the set of generators and chips on the current floor
    std::vector<std::pair<unsigned int, unsigned int>> gc;
    unsigned int index = 0;
    for(unsigned int i = 0; i < elements.size(); i++) {
      if(elements[i].first == floor)
        gc.emplace_back(i, GENERATOR);
      if(elements[i].second == floor)
        gc.emplace_back(i, CHIP);
    }

    // Move up and down
    int movement[] = {1, -1};
    for(unsigned int i = 0; i < sizeof(movement) / sizeof(int); i++) {
      // Discard illegal floor moves
      int new_floor = floor + movement[i];
      if(new_floor < 0 || new_floor >= 4)
        continue;

      // Do all single generator movements
      for(auto j = gc.begin(); j != gc.end(); j++) {
        State* s = new State(elements, new_floor, distance + 1);
        s->move((*j).first, (*j).second, movement[i]);
        if(s->valid())
          moves.push_back(s);
        else
          delete s;

        // For each permutation of pairs
        auto k = j; k++;
        for(; k != gc.end(); k++) {
          s = new State(elements, new_floor, distance + 1);
          s->move((*j).first, (*j).second, movement[i]);
          s->move((*k).first, (*k).second, movement[i]);
          if(s->valid())
            moves.push_back(s);
          else
            delete s;
        }
      }
    }
  }

private:
  // Move an element object the specified direction
  void move(unsigned int element, unsigned int object, int magnitude) {
    if(object == GENERATOR)
      elements[element].first += magnitude;
    else
      elements[element].second += magnitude;
  }

  // Is the state valid?
  bool valid() const {
    for(auto i = elements.begin(); i != elements.end(); i++) {
      if((*i).first == (*i).second)
        continue;
      for(auto j = elements.begin(); j != elements.end(); j++)
        if((*i).second == (*j).first)
          return false;
    }
    return true;
  };

private:
  Elements elements;
  unsigned int floor;
  unsigned int distance;
  long guid;
};

int main(void) {
  // Initial problem state
  std::vector<ElementPair> input = {{0,0},{0,1},{0,1},{2,2},{2,2}};
  State* state = new State(input);

  // A FIFO queue for our breadth-first search (O(1) insert and delete)
  std::list<State*> queue;
  queue.push_back(state);

  // A set of seen node GUIDs (O(log N) search)
  std::set<unsigned long> seen;
  seen.insert(state->getGuid());

  // Process the FIFO queue in order...
  State* u;
  while(!queue.empty()) {
    // Select the current node
    u = queue.front();
    queue.pop_front();

    // Simulation complete, break out
    if(u->done())
      break;

    // Get a list of valid moves
    std::list<State*> moves;
    u->getMoves(moves);

    // For each state if we've not seen it, queue it up and mark seen
    for(auto i = moves.begin(); i != moves.end(); i++) {
      if(seen.find((*i)->getGuid()) == seen.end()) {
        queue.push_back(*i);
        seen.insert((*i)->getGuid());
      }
    }
  }

  std::cout << u->getDistance() << std::endl;

  return 0;
}
