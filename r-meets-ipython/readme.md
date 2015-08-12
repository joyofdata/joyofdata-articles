#Ubuntu 14.04

##Bash:

`pip install --upgrade jupyter`

Source: [http://blog.jupyter.org/2015/08/12/first-release-of-jupyter/]()

#R:

```
install.packages(c('rzmq','repr','IRkernel','IRdisplay'),
                 repos = c('http://irkernel.github.io/', getOption('repos')),
                 type = 'source')

IRkernel::installspec()
```

Source: [https://github.com/IRkernel/IRkernel]()
