#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <linux/kvm.h>

#define KVM_DEV		"/dev/kvm"
#define GUEST_BIN	"./guest.bin"

int main(int argc, const char *argv[])
{
	int kvm_fd;
	int vm_fd;
	int vcpu_fd;
	int guest_fd;
	int ret;
	int mmap_size;

	struct kvm_userspace_memory_region mem;
	struct kvm_run *kvm_run;
	struct kvm_one_reg reg;
	void *userspace_addr;

	kvm_fd = open(KVM_DEV, O_RDWR);
	assert(kvm_fd > 0);

	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
	assert(vm_fd > 0);

	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
	assert(vcpu_fd > 0);

	guest_fd = open(GUEST_BIN, O_RDONLY);
	assert(guest_fd > 0);

	userspace_addr = mmap(NULL, 0x2000, PROT_READ|PROT_WRITE,
		MAP_SHARED|MAP_ANONYMOUS, -1, 0);
	assert(userspace_addr > 0);

	ret = read(guest_fd, userspace_addr, 0x1000);
	assert(ret > 0);

	mem.slot = 0;
	mem.flags = 0;
	mem.guest_phys_addr = 0x100000;
	mem.userspace_addr = (unsigned long)userspace_addr;
	mem.memory_size = 0x200000;
	ret = ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
	assert(ret > 0);
	mmap_size = ioctl(kvm_fd, KVM_GET_VCPU_MMAP_SIZE, NULL):
	assert(mmap_size > 0);

	kvm_run = (struct kvm_run *)mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpu_fd, 0);
	assert(kvm_run >= 0);

#define AARCH64_CORE_REG(x)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))

	reg.id = AARCH64_CORE_REG(regs.pc);
	reg.addr = 0x100000;
	ret = ioctl(vcpu_fd, KVM_SET_ONE_REG, &reg);
	assert(ret >= 0);

	while(1) {
		ret = ioctl(vcpu_fd, KVM_RUN, NULL);
		assert(ret >= 0);

		switch (kvm_run->exit_reason) {
		default:
			 printf("Unknow exit reason: %d\n", kvm_run->exit_reason);
			 break;
		}
	}

	return 0;
}
