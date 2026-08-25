// MSVC static-thread builds: boost expects the application to define this
// hook (thread/src/tss_null.cpp self-disables under _MSC_VER). Empty by
// design -- TSS cleanup is handled by the thread sources themselves.
namespace boost
{
    void tss_cleanup_implemented(void)
    {
    }
}
