SAMSUMG_DTB := arch/$(SRCARCH)/boot/dts/samsung
QCOM_DTB := arch/$(SRCARCH)/boot/dts/qcom

define sec_dtbo_build
$(foreach dtbo, $(1), $(eval $(call __sec_dtbo_build, $(dtbo),$(2),$(3))))
endef

# SDM845 BASE DTB
SEC_SDM845_BASE_DTB := $(QCOM_DTB)/sdm845.dtb $(QCOM_DTB)/sdm845-v2.dtb $(QCOM_DTB)/sdm845-v2.1.dtb

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)

SEC_SDM845_SPU_DTBO := \
		common/sdm845-sec-system-update-overlay.dtbo

$(eval $(call sec_dtbo_build, \
		$(SEC_SDM845_SPU_DTBO),$(CONFIG_ARCH_SDM845),$(SEC_SDM845_BASE_DTB)))

endif

dts-dirs += chn

always          := $(dtb-y)
subdir-y        := $(dts-dirs)

$(obj)/../%.dtb: $(src)/%.dts FORCE
        $(call if_changed_dep,dtc)

dtbs: $(addprefix $(obj)/../,$(dtb-y))
endif
clean-files := *.dtb *.reverse.dts *.dtbo

