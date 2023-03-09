{
  :title "QRNG using Qiskit and IBMQ"
  :layout :post
  :tags ["python", "quantum computing"]
  :toc true}
 
 ---

## Tools

1. Python environment
2. Account on [IBM Quantum](https://quantum-computing.ibm.com/)
3. Qiskit Library

## Implementation

```python
from qiskit import IBMQ, Aer, assemble, transpile
from qiskit import QuantumCircuit, ClassicalRegister, QuantumRegister
from qiskit.providers.ibmq import least_busy
from qiskit.tools.monitor import job_monitor
import operator
import struct

class QRNG:
    def __init__(self, account_token="", use_real_quantum_device=False):
        self.__bits_pool=[]
        self.__account_token=account_token
        self.__real_quantum = use_real_quantum_device
        
    def initialize(self):
        self.__init_ibmq()
        self.__create_circuit()
        self.__init_pool()
        
    def get_int32(self):
        return int(self.__get_bit_string(32),2)
    
    def get_int8(self):
        return int(self.__get_bit_string(8),2)
    
    def get_int16(self):
        return int(self.__get_bit_string(16),2)
    
    def get_int64(self):
        return int(self.__get_bit_string(64),2)
    
    def get_float(self, min=0, max=1):
        unpacked = 0x3F800000 | self.get_int32() >> 9
        packed = struct.pack('I',unpacked)
        value = struct.unpack('f',packed)[0] - 1.0
        return (max-min)*value+min
    
    def get_double(self, min=0,max=1):
        unpacked = 0x3FF0000000000000 | self.get_int64() >> 12
        packed = struct.pack('Q',unpacked)
        value = struct.unpack('d',packed)[0] - 1.0
        return (max-min)*value+min # Scale double to given range
    
    def __init_ibmq(self):
        if not self.__account_token or self.__real_quantum==False:
            # no token, so use simulator
            self.__backend=Aer.get_backend('aer_simulator')
            self.__no_of_qubits_available=32
        else:
            IBMQ.save_account(self.__account_token)
            IBMQ.load_account()
            provider = IBMQ.get_provider("ibm-q")
            self.__backend = least_busy(provider.backends(filters=lambda x: int(x.configuration().n_qubits) >= 3 and 
                                   not x.configuration().simulator and x.status().operational==True))
            self.__no_of_qubits_available = self.__backend.configuration().n_qubits
            print(f"least busy backend: {self.__backend}, with {self.__no_of_qubits_available} qubits available")
    
    def __create_circuit(self):
        qr = QuantumRegister(self.__no_of_qubits_available)
        cr = ClassicalRegister(self.__no_of_qubits_available)
        self.__qcircuit = QuantumCircuit(qr,cr)
        self.__qcircuit.h(qr)
        self.__qcircuit.measure(qr,cr)
        self.__transpiled_circuit = transpile(self.__qcircuit, self.__backend, optimization_level=3)
        
    def __init_pool(self):
        #print("Init pool")
        self.__bits_pool=self.__get_random_bits()
        self.__pool_size = len(self.__bits_pool)
        # print(f"{len(self.__bits_pool)}")
    
    def __get_random_bits(self):
        job = self.__backend.run(self.__transpiled_circuit)
        job_monitor(job, interval=2)
        counts = job.result().get_counts(self.__qcircuit)
        return self.__bits_from_counts(counts)
    
    def __bits_from_counts(self,counts):
        #max_item =max(counts.items(), key=operator.itemgetter(1))
        #return max_item[0]
        value = [k for k, v in counts.items()]
        return ''.join(value)
    
    def __get_bit_string(self,n):
        if n>(self.__pool_size*self.__no_of_qubits_available):
            raise Exception("The number of required bits is greater than the number of bits available in pool")
        if not self.__bits_pool or n>len(self.__bits_pool):
            self.initialize() #reinitialize the circuit if the pool is empty. This way, we can run again on the least busy quantum processor
        bit_string = self.__bits_pool[:n]
        self.__bits_pool = self.__bits_pool[n:]
        return bit_string
```

## How to use it?

```python
qrng = QRNG("<IBMQ Account Token>",use_real_quantum_device=True)
qrng.initialize()
for _ in range(10):
    value = qrng.get_int8()
    print(f"Random value: {value}")
```

## Known Limitations

Currently it can only generate unsigned int values on 8,16,32, and 64 bits. I will update this post as soon as the support for signed values is added.