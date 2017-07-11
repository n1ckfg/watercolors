class Drop {

  int numSlices = 4; // 30
  int numBaseReps = 3; // 7
  int numDetailReps = 2; // 5
  ArrayList<DropSlice> slices;
  PVector p;
  float dropSize = 20;
  
  Drop(PVector _p) {
    p = _p;
    slices = new ArrayList<DropSlice>();
    for (int i=0; i<numSlices; i++) {
      if (i==0) {
        slices.add(new DropSlice(p, dropSize, numBaseReps));
      } else {
        slices.add(new DropSlice(p, dropSize, numDetailReps, slices.get(0).vertices));
      }
    }
  }

  void run() {
    for (int i=0; i<slices.size(); i++) {
      DropSlice s = slices.get(i);
      s.p = p;
      s.run();
    }
  }
  
}