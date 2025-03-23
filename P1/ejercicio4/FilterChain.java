
package ejercicio4;

import java.util.ArrayList;
import java.util.List;

public class FilterChain {
    private List<Filter> filters = new ArrayList<>();
    private AuthTarget target;

    public void addFilter(Filter filter) {
        filters.add(filter);
    }

    public void setTarget(AuthTarget target) {
        this.target = target;
    }

    public void execute(Message message) throws Exception {
        for (Filter filter : filters) {
            filter.execute(message);
        }

        if (target != null) {
            target.authenticate(message);
        }
    }
}