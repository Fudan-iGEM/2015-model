# iGEM_fudan_2015
fudan iGEM 2015 - Cyclize It! - modeling part 

The repository includes the configuration files and few log files for the Molecular Dynamics (MD) modeling we performed in the iGEM 2015 project. In brief, we did MD simulation to investigate the linker conformation in our fusion protein design, which in turn may guide our design. Unfortunately, we didn't finish the program back in 2015, due to the limited time and computational resources. This repository is to only provide the original scripts and data to show how we configurate the MD simulation of a cyclic protein and how we used it to help optimal linker design. Due to the size limit of GitHub, we didn't include the output files (trajectory files) of this simulation. 


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

The auxiliary scripts in Python language were developed and tested in Python 2.7. 

The binary programs used to perform MD have been included in the repository.


## Running the tests

To reproduce or test the MD simulation, please check out the below folders. We performed the MD mostly via NAMD graphic interface.

model/alignment/: align the two PUF protein for next step use

model/make templete/: generate the artificial fusion protein that contains two PUF and the designed linker. Note that the product protein is a cyclic protein. This is mainly achieved by pymol operation which can be reproduced by following "pymol script.txt"

model/model/: generate model inputs for MD simulation from the PDB file

model/MD_flexible_linker/: the MD simulation of flexible linker design. See "mod.conf" for configurations. 

model/MD_rigid_linker/: the MD simulation of rigid linker design. See "mod.conf" for configurations. 

model/MD_force_pulling/: the MD simulation where we force pulling the two PUF apart to access the maximum length of the flexible linker. See "mod.conf" for configurations. 


