/* Used to calculate the Budget */
var Budget = {
    toAmount: function(value) {
        var amount = value.replace(/[^1234567890.]/ig,'');
        if (amount) {
            return parseFloat(amount);
        } else {
            return 0;
        }
    },

    updateAmounts: function() {
        if ($('#deliverable_type').checked) {
            // Fixed cost
            var cost = Budget.toAmount($('#deliverable_fixed_cost').val());
            Budget.updateAmount($('#fixedCost'), cost);
        } else {
            // Variable cost
            var perHour = Budget.toAmount($('#deliverable_cost_per_hour').val());
            var hours = Budget.toAmount($('#deliverable_total_hours').val());

            var cost = perHour * hours;
            Budget.updateAmount($('#variableCost'), cost);
        }


        if ($('#deliverable_overhead').val().match('%')) {
            var overhead_subtotal =  (Budget.toAmount($('#deliverable_overhead').val()) / 100) * cost;
        } else {
            var overhead_subtotal =  Budget.toAmount($('#deliverable_overhead').val());
        }

        if ($('#deliverable_materials').val().match('%')) {
            var materials_subtotal =  (Budget.toAmount($('#deliverable_materials').val()) / 100) * cost;
        } else {
            var materials_subtotal =  Budget.toAmount($('#deliverable_materials').val());
        }

        // Profit uses labor cost and overhead
        if ($('#deliverable_profit').val().match('%')) {
            var profit_subtotal =  (Budget.toAmount($('#deliverable_profit').val()) / 100) * (cost + overhead_subtotal);
        } else {
            var profit_subtotal =  Budget.toAmount($('#deliverable_profit').val());
        }

        // Amounts
        Budget.updateAmount($('#overhead_subtotal'), overhead_subtotal);
        Budget.updateAmount($('#materials_subtotal'), materials_subtotal);
        Budget.updateAmount($('#profit_subtotal'), profit_subtotal);

        var total = cost + overhead_subtotal + materials_subtotal + profit_subtotal;
        $('#deliverable_budget').val(total);
        $('#total-budget-calculation').html(Budget.number_to_currency(total));
    },

    updateAmount: function(element, value) {
        if (element) {
            element.html(Budget.number_to_currency(value));
        }
    },

    changeType: function() {
        if ($('#deliverable_type').checked) {
            // Fixed
            $('.budget-hourly').hide();
            $('.budget-fixed').show();
        } else {
            // Variable
            $('.budget-hourly').show();
            $('.budget-fixed').hide();
        }
        Budget.updateAmounts();
    },

    // Rails-like number_to_currency currency formatting
    // http://snippets.dzone.com/posts/show/4646
    number_to_currency: function (number, options) {
        try {
            var options   = options || {};
            var precision = options["precision"] || 2;
            var unit      = options["unit"] || "$";
            var separator = precision > 0 ? options["separator"] || "." : "";
            var delimiter = options["delimiter"] || ",";

            var parts = parseFloat(number).toFixed(precision).split('.');
            return unit + Budget.number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString();
        } catch(e) {
            return number;
        }
    },

    number_with_delimiter: function (number, delimiter, separator) {
        try {
            var delimiter = delimiter || ",";
            var separator = separator || ".";

            var parts = number.toString().split('.');
            parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
            return parts.join(separator);
        } catch(e) {
            return number
        }
    }
};

function toggleAll() {
    $('.deliverable-details, .toggle').toggle();
}

function expandRow(deliverable_id) {
    $('#deliverable-details-'+ deliverable_id).show();
    $('#deliverable-description-'+ deliverable_id).show();
    $('.toggle_' + deliverable_id).toggle();
}

function collapseRow(deliverable_id) {
    $('#deliverable-details-'+ deliverable_id).hide();
    $('#deliverable-description-'+ deliverable_id).hide();
    $('.toggle_' + deliverable_id).toggle();
}
