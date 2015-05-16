# -*- coding: utf-8 -*-
"""
Created on Fri May 15 15:45:30 2015

@author: c_kazum
"""
from gplearn.genetic import SymbolicTransformer
from sklearn.utils import check_random_state
from sklearn.datasets import load_boston
import numpy as np
#In [2]:
rng = check_random_state(0)
boston = load_boston()
perm = rng.permutation(boston.target.size)
boston.data = boston.data[perm]
boston.target = boston.target[perm]
#In [3]:
from sklearn.linear_model import Ridge
est = Ridge()
est.fit(boston.data[:300, :], boston.target[:300])
print( est.score(boston.data[300:, :], boston.target[300:]))

#0.759145222183

#In [4]:
gp = SymbolicTransformer(generations=20, population_size=2000,
                         hall_of_fame=100, n_components=10,
                         parsimony_coefficient=0.0005,
                         max_samples=0.9, verbose=1,
                         random_state=0, n_jobs=3)
gp.fit(boston.data[:300, :], boston.target[:300])

gp_features = gp.transform(boston.data)
new_boston = np.hstack((boston.data, gp_features))

est = Ridge()
est.fit(new_boston[:300, :], boston.target[:300])
print
print est.score(new_boston[300:, :], boston.target[300:])
"""
    |    Population Average   |             Best Individual              |
---- ------------------------- ------------------------------------------ ----------
 Gen   Length          Fitness   Length          Fitness      OOB Fitness  Time Left
   0    11.04   0.339498855737        3   0.827183303904   0.541134538986     18.40s
   1     6.76   0.595607349765        8   0.844142294401   0.573168891668     35.67s
   2     5.24   0.720496338383        8   0.837040776431   0.803783328827     43.07s
   3     5.42    0.73925734877        5   0.859489370651   0.580813223319     43.00s
   4     6.94   0.724145477149        5   0.851564721312   0.515829829967     43.03s
   5     8.75   0.706072480163       12   0.862081380781   0.464620353508     41.37s
   6     9.43    0.72277984526       18     0.8665540822   0.551898967312     39.25s
   7     9.81   0.728222217883        7   0.869930319583   0.694780730698     37.29s
   8    10.34   0.732589362714       12   0.869313590585   0.448107338283     35.50s
   9    11.16   0.734340696331       17   0.883909797276   0.270701561723     32.44s
  10    12.16   0.729281362528       16   0.874698247831   0.674636068361     29.79s
  11    12.46   0.737088899817       16   0.894847045579   0.518452153686     27.02s
  12    13.29   0.739501531533       12   0.887976166981   0.357492283612     23.73s
  13    14.63   0.741643980373       26   0.879131892265   0.654348374775     20.52s
  14    14.96   0.739061407427       10   0.889673804666    0.64791087565     17.45s
  15     14.8   0.744507271997        7   0.884463701515   0.590221266092     14.03s
  16    13.82   0.746421818109        9   0.879741752097   0.547792331302     10.55s
  17    12.74   0.741150864918        9   0.883680241981   0.653907719289      7.04s
  18    12.67   0.744074323927       13   0.891438924283   0.625966781137      3.55s
  19    12.31   0.754357486199        7   0.882399412561   0.618761173259      0.00s

0.853618353633
"""