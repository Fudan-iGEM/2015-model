from modeller import *

env = environ()
aln = alignment(env)
mdl = model(env, file='templete', model_segment=('FIRST:A','LAST:B'))
aln.append_model(mdl, align_codes='templete', atom_files='templete.pdb')
aln.append(file='cyc.ali', align_codes='cyc')
aln.align2d()
aln.write(file='cyc-templete.ali', alignment_format='PIR')
aln.write(file='cyc-templete.pap', alignment_format='PAP')
