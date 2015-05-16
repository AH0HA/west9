# -*- coding: utf-8 -*-
"""
Created on Thu May 14 17:37:26 2015

@author: c_kazum
"""


from gplearn import genetic as ge

#gp.fit(boston.data[:300, :], boston.target[:300])

def train():
    weather = load_weather()
    training = load_training()
    
    X = assemble_X(training, weather)
    y = assemble_y(training)
    """
    input_size = len(X[0])
    
    learning_rate = theano.shared(np.float32(0.1))
    
    net = NeuralNet(
    layers=[  
        ('input', InputLayer),
         ('hidden1', DenseLayer),
        ('dropout1', DropoutLayer),
        ('hidden2', DenseLayer),
        ('dropout2', DropoutLayer),
        ('output', DenseLayer),
        ],
    # layer parameters:
    input_shape=(None, input_size), 
    hidden1_num_units=256, 
    dropout1_p=0.4,
    hidden2_num_units=256, 
    dropout2_p=0.4,
    output_nonlinearity=sigmoid, 
    output_num_units=1, 

    # optimization method:
    update=nesterov_momentum,
    update_learning_rate=learning_rate,
    update_momentum=0.9,
    
    # Decay the learning rate
    on_epoch_finished=[
            AdjustVariable(learning_rate, target=0, half_life=4),
            ],

    # This is silly, but we don't want a stratified K-Fold here
    # To compensate we need to pass in the y_tensor_type and the loss.
    regression=True,
    y_tensor_type = T.imatrix,
    objective_loss_function = binary_crossentropy,
     
    max_epochs=32, 
    eval_size=0.1,
    verbose=1,
    )
    """
    X, y = shuffle(X, y, random_state=123)
    
gp = ge.SymbolicTransformer(generations=20, population_size=2000,
                         hall_of_fame=100, n_components=10,
                         parsimony_coefficient=0.0005,
                         max_samples=0.9, verbose=1,
                         random_state=0, n_jobs=3)    
                         
    gp.fit(X, y)
    #net.fit(X, y)
    
    _, X_valid, _, y_valid = net.train_test_split(X, y, net.eval_size)
    probas = net.predict_proba(X_valid)[:,0]
    print("ROC score", metrics.roc_auc_score(y_valid, probas))

    return net        