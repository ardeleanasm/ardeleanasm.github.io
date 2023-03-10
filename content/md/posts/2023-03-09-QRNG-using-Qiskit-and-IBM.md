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
class QRNG:
    class QRNGCircuit:
        def __init__(self, account_token = "", is_real_device = False):
            self.__account_token=account_token
            self.__is_real_device = is_real_device
            if not self.__account_token or self.__is_real_device==False:
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
            self.__bits_pool=self.__generate_random_values()
            self.__pool_size = len(self.__bits_pool)
                
        def generate_random_bitstring(self,n):
            if n>(self.__pool_size*self.__no_of_qubits_available):
                raise Exception("The number of required bits is greater than the number of bits available in pool")
            if not self.__bits_pool or n>len(self.__bits_pool):
                self.__bits_pool=self.__generate_random_values()
                self.__pool_size = len(self.__bits_pool)
            bit_string = self.__bits_pool[:n]
            self.__bits_pool = self.__bits_pool[n:]
            return bit_string
        
        
        
        def __generate_random_values(self):
            qr = QuantumRegister(self.__no_of_qubits_available)
            cr = ClassicalRegister(self.__no_of_qubits_available)
            qcircuit = QuantumCircuit(qr,cr)
            qcircuit.h(qr)
            qcircuit.measure(qr,cr)
            transpiled_circuit = transpile(qcircuit, self.__backend, optimization_level=3)
            job = self.__backend.run(transpiled_circuit)
            job_monitor(job, interval=2)
            counts = job.result().get_counts(qcircuit)
            return self.__bits_from_counts(counts)
        
        def __bits_from_counts(self,counts):
            #max_item =max(counts.items(), key=operator.itemgetter(1))
            #return max_item[0]
            value = [k for k, v in counts.items()]
            return ''.join(value)
        
    def __init__(self, account_token="", is_real_device=False):
        self.__qrng = self.QRNGCircuit(account_token,is_real_device)
        
        
    def get_int8(self):
        bitstring=self.__qrng.generate_random_bitstring(8)
        value = struct.unpack('b',struct.pack('B',int(bitstring,2)))[0]
        return value
        
    def get_int16(self):
        bitstring=self.__qrng.generate_random_bitstring(16)
        value = struct.unpack('h',struct.pack('H',int(bitstring,2)))[0]
        return value
    
    def get_int32(self):
        bitstring=self.__qrng.generate_random_bitstring(32)
        value = struct.unpack('i',struct.pack('I',int(bitstring,2)))[0]
        return value
    
    def get_int64(self):
        bitstring=self.__qrng.generate_random_bitstring(64)
        value = struct.unpack('q',struct.pack('Q',int(bitstring,2)))[0]
        return value
   

    def get_float(self, min=0, max=1):
        unpacked = 0x3F800000 | abs(self.get_int32()) >> 9
        packed = struct.pack('I',unpacked)
        value = struct.unpack('f',packed)[0] - 1.0
        return (max-min)*value+min
    
    def get_double(self, min=0,max=1):
        unpacked = 0x3FF0000000000000 | abs(self.get_int64()) >> 12
        packed = struct.pack('Q',unpacked)
        value = struct.unpack('d',packed)[0] - 1.0
        return (max-min)*value+min # Scale double to given range
```

## How to use it?

```python
qrng = QRNG("<IBMQ Account Token>",use_real_quantum_device=True)
qrng.initialize()
for _ in range(10):
    value = qrng.get_int8()
    print(f"Random value: {value}")
```

## Results

```
Random value: 0.22334390822625294
Random value: 0.11913887754327823
Random value: 0.279900932932571
Random value: 0.12946576523933073
Random value: 0.04196925444743771
Random value: 0.3103746334539752
Random value: 0.17299864593336678
Random value: 0.07880283725043769
Random value: 0.1796126361622985
Random value: 0.06989536086545933
```

