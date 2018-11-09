/* kernel_cfg.h */
#ifndef TOPPERS_KERNEL_CFG_H
#define TOPPERS_KERNEL_CFG_H

#define TNUM_TSKID	3
#define TSKID_tTask_LogTask_Task	1
#define INIT_MAIN_TASK	2
#define BLINKY_MAIN_TASK	3

#define TNUM_SEMID	2
#define SEMID_tSemaphore_SerialPort1_ReceiveSemaphore	1
#define SEMID_tSemaphore_SerialPort1_SendSemaphore	2

#define TNUM_FLGID	0

#define TNUM_DTQID	0

#define TNUM_PDQID	0

#define TNUM_MTXID	0

#define TNUM_MPFID	0

#define TNUM_CYCID	0

#define TNUM_ALMID	0

#define TNUM_ISRID	2
#define ISRID_tISR_SIOPortTarget1_RxISRInstance	1
#define ISRID_tISR_SIOPortTarget1_TxISRInstance	2

#endif /* TOPPERS_KERNEL_CFG_H */
