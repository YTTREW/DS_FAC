package ejercicio4;

class FilterManager {
    private FilterChain filterChain;

    public FilterManager(AuthTarget target) {
        filterChain = new FilterChain();
        filterChain.setTarget(target);
    }

    public void addFilter(Filter filter) {
        filterChain.addFilter(filter);
    }

    public void authenticate(Message message) throws Exception {
        filterChain.execute(message);
    }
}
