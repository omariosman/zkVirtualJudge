pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/poseidon.circom";

template GetHighestScore (participants_num) {
    signal input scores[participants_num];
    
    signal input scores_val_secret[participants_num][2]; //associating each score to a 2d array contains the secret and the score
    
    signal output highest_score[2];
    signal output scores_validity[participants_num];
    
    component hashes[participants_num];
     
    var highest_score_value = 0;
    var highest_score_hash = 0;
    
    for (var i = 0; i < participants_num; i++) {
      hashes[i] = Poseidon(2);
      hashes[i].inputs[0] <== scores_val_secret[i][0];
      hashes[i].inputs[1] <== scores_val_secret[i][1];

        //compare the output of the hashing both the value and the secret together with the hash of all the scores
        //This if condition is written to make sure that the winner score (value & secret hash) is one of the scores
      if (hashes[i].out == scores[i]) {
        // score was valid
        if (scores_val_secret[i][0] > highest_score_value) {
          // bid value is higher than previously recorded bid
          highest_score_value = scores_val_secret[i][0];
          highest_score_hash = scores[i];
        }
      }
      scores_validity[i] <-- hashes[i].out == scores[i];

    }
      highest_score[0] <-- highest_score_value;
        highest_score[1] <-- highest_score_hash;
    }
    
 component main { public [ scores ] } = GetHighestScore(4);
