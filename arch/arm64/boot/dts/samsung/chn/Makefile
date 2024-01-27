# SPDX-License-Identifier: GPL-2.0

define __sec_dtbo_build
dtbo-$(2) += $(1)
$(1)-base := $(3)
endef

define sec_dtbo_build
$(foreach dtbo, $(1), $(eval $(call __sec_dtbo_build, $(dtbo),$(2),$(3))))
endef

# SDM845 BASE DTB
QCOM_DTB := ../../dts/qcom
SEC_SDM845_BASE_DTB := $(QCOM_DTB)/sdm845.dtb $(QCOM_DTB)/sdm845-v2.dtb $(QCOM_DTB)/sdm845-v2.1.dtb

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)

# CHN
SEC_CHN_DTBO := sdm845-sec-starqlte-chn-r02.dtbo \
	sdm845-sec-starqlte-chn-r03.dtbo \
	sdm845-sec-starqlte-chn-r04.dtbo \
	sdm845-sec-starqlte-chn-r05.dtbo \
	sdm845-sec-starqlte-chn-r06.dtbo \
	sdm845-sec-starqlte-chn-r07.dtbo \
	sdm845-sec-starqlte-chn-r08.dtbo \
	sdm845-sec-starqlte-chn-r09.dtbo \
	sdm845-sec-starqlte-chn-r10.dtbo \
	sdm845-sec-starqlte-chn-r11.dtbo \
	sdm845-sec-starqlte-chn-r12.dtbo \
	sdm845-sec-starqlte-chn-r13.dtbo \
	sdm845-sec-starqlte-chn-r13_v2.1.dtbo \
	sdm845-sec-starqlte-chn-r14.dtbo	 \
	sdm845-sec-starqlte-chn-r14_v2.1.dtbo \
        sdm845-sec-star2qlte-chn-r02.dtbo \
	sdm845-sec-star2qlte-chn-r03.dtbo \
	sdm845-sec-star2qlte-chn-r04.dtbo \
	sdm845-sec-star2qlte-chn-r05.dtbo \
	sdm845-sec-star2qlte-chn-r06.dtbo \
	sdm845-sec-star2qlte-chn-r07.dtbo \
	sdm845-sec-star2qlte-chn-r08.dtbo \
	sdm845-sec-star2qlte-chn-r09.dtbo \
	sdm845-sec-star2qlte-chn-r10.dtbo \
	sdm845-sec-star2qlte-chn-r11.dtbo \
	sdm845-sec-star2qlte-chn-r12.dtbo \
	sdm845-sec-star2qlte-chn-r13.dtbo \
	sdm845-sec-star2qlte-chn-r13_v2.1.dtbo \
	sdm845-sec-star2qlte-chn-r14.dtbo \
	sdm845-sec-star2qlte-chn-r14_v2.1.dtbo \
	sdm845-sec-crownqlte-chn-r03.dtbo \
	sdm845-sec-crownqlte-chn-r05.dtbo \
	sdm845-sec-crownqlte-chn-r06.dtbo \
	sdm845-sec-crownqlte-chn-r10.dtbo

$(eval $(call sec_dtbo_build, \
		$(SEC_CHN_DTBO),$(SEC_SDM845_BASE_DTB))

endif
