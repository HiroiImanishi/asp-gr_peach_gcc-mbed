/*
 * このファイルは tecsgen により自動生成されました
 * このファイルを編集して使用することは、意図されていません
 */
#include "tISR_tecsgen.h"
#include "tISR_factory.h"


/* 呼び口の参照する受け口ディスクリプタ(実際の型と相違した定義) #_CPEPD_# */
extern struct tag_siHandlerBody_VDES SIOPortTarget1_SCIF_eiRxISR_des;

extern struct tag_siHandlerBody_VDES SIOPortTarget1_SCIF_eiTxISR_des;

/* 呼び口配列 #_CPA_# */


/* 属性・変数の配列 #_AVAI_# */
/* セル INIB #_INIB_# */
tISR_INIB tISR_INIB_tab[] = {
    /* cell: tISR_CB_tab[0]:  SIOPortTarget1_RxISRInstance id=1 */
    {
        /* call port (INIB) #_CP_# */ 
        &SIOPortTarget1_SCIF_eiRxISR_des,        /* ciISRBody #_CCP1_# */
        /* attribute(RO) */ 
        ISRID_tISR_SIOPortTarget1_RxISRInstance, /* id */
    },
    /* cell: tISR_CB_tab[1]:  SIOPortTarget1_TxISRInstance id=2 */
    {
        /* call port (INIB) #_CP_# */ 
        &SIOPortTarget1_SCIF_eiTxISR_des,        /* ciISRBody #_CCP1_# */
        /* attribute(RO) */ 
        ISRID_tISR_SIOPortTarget1_TxISRInstance, /* id */
    },
};

/* 受け口ディスクリプタ #_EPD_# */
/* CB 初期化コード #_CIC_# */
void
tISR_CB_initialize()
{
    tISR_CB	*p_cb;
    int		i;
    FOREACH_CELL(i,p_cb)
        SET_CB_INIB_POINTER(i,p_cb)
        INITIALIZE_CB(p_cb)
    END_FOREACH_CELL
}
