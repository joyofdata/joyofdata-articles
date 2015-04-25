# this file is not intended to be run at once
# but instead manually line by line

sudo apt-get install lynx-cur
sudo apt-get install unzip
sudo apt-get install imagemagick

# A 100 GB EBS volume is mounted at ~/data

# make sure that temporary download files are stored on the EBS
export LYNX_TEMP_SPACE=~/data
lynx www.kaggle.com

cat train.zip.* > train.zip
unzip train.zip -d .

mkdir ~/data/training_0
mkdir ~/data/training_0/train_sm
mkdir ~/data/training_0/train_sm_180
mkdir ~/data/training_0/train_sm_flop
mkdir ~/data/training_0/train_sm_180_flop

# transforming the original JPEGs into four versions

for f in ~/data/train/*.jpeg
do
  convert $f -fuzz 15% -trim -resize 256x256 \
    -background black -gravity center -extent 256x256 \
    ~/data/training_0/train_sm/$(basename -s .jpeg $f).png
done

for f in ~/data/training_0/train_sm/*.png
do
  convert $f -rotate 180 ~/data/training_0/train_sm_180/$(basename $f)
done

for f in ~/data/training_0/train_sm/*.png
do
  convert $f -flop ~/data/training_0/train_sm_flop/$(basename $f)
done

for f in ~/data/training_0/train_sm_180/*.png
do
  convert $f -flop ~/data/training_0/train_sm_180_flop/$(basename $f)
done

# trainLabels.csv is provided by Kaggle for the training data set

# skip first line, adjust paths, add extension, treat label {1,..,4} as 1
tail -n +2 trainLabels.csv | \
  sed 's/,/.png\t/g' | \
  sed 's#^#/home/ubuntu/data/training_0/train_sm/#g' | \
  sed 's/[234]$/1/g' \
  > training_0/imgs.csv
  
# manual intermediate step:
# remove images which caused errors during above transformations (about 15)

# create four lists (img,label) for all four versions
cp imgs.csv train_sm.csv
sed 's/train_sm/train_sm_180/g' imgs.csv > train_sm_180.csv
sed 's/train_sm/train_sm_flop/g' imgs.csv > train_sm_flop.csv
sed 's/train_sm/train_sm_180_flop/g' imgs.csv > train_sm_180_flop.csv

# combine, shuffle and save in one file
cat train_sm*.csv | shuf > train_all.csv

# first 2000 images for testing
# next 6000 images for validation
# rest for training
sed -n '1,2000p' <  train_all.csv > testing.csv
sed -n '2001,8000p' <  train_all.csv > validation.csv
sed -n '8001,$p' <  train_all.csv > training.csv
