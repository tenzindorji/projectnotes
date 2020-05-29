for p in `cat /pythongLearning/qa-prf-pci-instances`
do
    echo "${p}"
    make ipall|grep "${p}" >>  /tmp/qa_prf_pci.txt
done
