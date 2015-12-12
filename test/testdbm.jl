using Boltzmann
using MNIST

function run_mnist()
	X, y = traindata()  
	normalize_samples!(X)
	binarize!(X;threshold=0.01)

	# X=X[:,1:10000]
	TrainSet = X[:,1:1000]
	ValidSet = X[:,59001:60000]
	Epochs = 1;
	MCMCIter = 1;
	EMFIter = 3
	LearnRate = 0.005
	MonitorEvery = 1
	EMFPersistStart = 5
	HiddenUnits1 = 500
	HiddenUnits2 = 100
	HiddenUnits3 = 10

	rbm1 = BernoulliRBM(28*28, 			HiddenUnits1, (28,28); momentum=0.5, TrainData=TrainSet, sigma = 0.01)
	rbm2 = BernoulliRBM(HiddenUnits1, 	HiddenUnits2, (HiddenUnits1,1); momentum=0.5, sigma = 0.01)
	rbm3 = BernoulliRBM(HiddenUnits2, 	HiddenUnits3, (HiddenUnits2,1); momentum=0.5, sigma = 0.01)

    	layers = [("vishid1",  rbm1),
          		("hid1hid2", rbm2),
          		("hid2hid3", rbm3)]
	dbm = DBM(layers)


	println(dbm)
	println(dbm[1])

	# finalrbm,monitor = fit_doubled(rbm1,TrainSet,"output";persistent=true, 
	# 					    lr=LearnRate, 
	# 						n_iter=Epochs, 
	# 						batch_size=100, 
	# 						NormalizationApproxIter=EMFIter,
	# 		             	weight_decay="l2",decay_magnitude=0.01,
	# 		             	# validation=ValidSet,
	# 		             	monitor_every=MonitorEvery,
	# 		             	monitor_vis=true,
	# 		             	approx="tap2",
	# 		            	persistent_start=EMFPersistStart)

	finaldbm = pre_fit(dbm,TrainSet;persistent=true, 
				lr=LearnRate, 
				n_iter=Epochs, 
				batch_size=100, 
				Normaliz tionApproxIter=EMFIter,
			             	weight_decay="l2",decay_magnitude=0.01,
			             	validation=[],
			             	monitor_every=MonitorEvery,
			             	monitor_vis=true,
			             	approx="tap2",
			            	persistent_start=EMFPersistStart)

	# mhid2=ProbHidAtLayerCondOnVis(dbm,X,2)
	# println(size(mhid2)) 
	# mhid1=ProbHidCondOnNeighbors(dbm[1],X,dbm[2],mhid2)
	# println(size(mhid1))
	# println(mhid1)  
	# finaldbm,monitor = fit(dbm, TrainSet; persistent=true, 
	# 					    lr=LearnRate, 
	# 						n_iter=Epochs, 
	# 						batch_size=100, 
	# 						NormalizationApproxIter=EMFIter,
	# 		             	weight_decay="l2",decay_magnitude=0.01,
	# 		             	validation=ValidSet,
	# 		             	monitor_every=MonitorEvery,
	# 		             	monitor_vis=true,
	# 		             	approx="tap2",
	# 		            	persistent_start=EMFPersistStart)
	# WriteMonitorChartPDF(finaldbm,monitor,X,"testmonitor_dbm_tap2.pdf")
 #    SaveMonitorHDF5(monitor,"testmonitor_dbm_tap2.h5")

end

run_mnist()

# fit(dbn, X)
# transform(dbn, X)

# dae = unroll(dbn)
# transform(dae, X)

# save_params("test.hdf5", dbn)
# save_params("test2.hdf5", dae)
# rm("test.hdf5")
# rm("test2.hdf5")
