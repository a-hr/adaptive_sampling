# How to run Adaptive Sampling experiments

This document describes how to run Adaptive Sampling with the ONT P2Solo sequencer.

## Step 1 - Prepare the target regions

You will need a BED file containing the target regions you want to sequence. This file should be in the following format (no headers required in the actual file):

```
chr	start	end	name	*	strand
```

> A sample file `adaptive_sampling_jun24.bed` is provided in this repository.

The whole covered regions should span between the 0.1% and 10% of the genome, ideally around 1~2%.

You can check that your BED file is correct though the following link: [BED file validator](https://labs.epi2me.io/bed-bugs/).

> Note: the name is arbitrary and can be any string. 

> Note 2: the file MUST be tab-separated.

## Step 2 - Buffer calculation

Once the library is prepared, you will need to calculate the buffer size for the target regions. For this purpose, a short 30-minute sequencing run is required.

Make sure to switch on the **basecalling**, as it is required to calculate the buffer size. If you forgot to activate the basecalling, you can always basecall the output `pod5` files.

Once run, look for a `sequencing_summary*.txt` file in the output folder. This file contains the information required to calculate the buffer size.

Now, head to RStudio and open the `1_getN.R` script. Change the path to the summary file and run to get the estimated N1 length. If you wish to get any other N-metric, simply change the `probs` argument to the one you need:
```R
n1 <- unname(quantile(data$sequence_length_template, probs = .99))
```

With the buffer size computed, it is time to insert it into our BED file. In order to do that, head to the `2_add_buffer.R` script and change the path to the BED file and the buffer size. Run the script to get the new BED file with the buffer size added to both ends of each target region.

## Step 3 - Running the Adaptive Sampling

It is time to run the experiment, but for that, MinKNOW needs a couple of files:

1. Locate the reference genome FASTA file you will use for the experiment.
2. Locate your BED file with the buffer size added.
3. Move both files to the `references` folder in the MinKNOW installation directory and change the ownership and permissions on the files:

```bash
sudo su -
mkdir -p /var/lib/minknow/data/references  # create if not present

# move the files to the MinKNOW dir
mv GRCh38.primary_assembly.genome.fa /var/lib/minknow/data/references/
mv buffer_adaptive_sampling_jun24.bed /var/lib/minknow/data/references/

# Change the permissions
chmod -R 775 /var/lib/minknow/data/references
chown -R minknow:minknow /var/lib/minknow/data/references
```

Once this is done, you are good to start the run! 

- Open MinKNOW and create a new experiment. Select the reference genome and the BED file with the buffer size.
- DO NOT activate basecalling during Adaptive Sampling. It should be done after the run is finished.
